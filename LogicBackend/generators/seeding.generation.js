const Admins = require('../models/admins.mongo');
const { faker } = require('@faker-js/faker');
const User = require('../models/users.mongo');
const Product = require('../models/products.mongo');
const Favorite = require('../models/favorites.mongo');
const Notification = require('../models/notifications.mongo');
const bcrypt = require('bcryptjs');
const locations = require('../public/json/countries-all.json');
const numbers = require('../public/json/phone_number.json');
const fs = require('fs');
const path = require('path');
const csv = require('csv-parser');
const Interaction = require('../models/interactions.mongo');
const { WEIGHT_MAP, INTERACTION_TYPES } = require('../public/constants/interaction');
const ChatbotInteraction = require('../models/chatbot_interaction.mongo');
const RecommendationInteraction = require('../models/recommendation_interaction.mongo');
const Order = require('../models/orders.mongo');
const OrderItem = require('../models/orderItem.mongo');
const fsp = require('fs').promises;
const Cart = require('../models/cart.mongo');

// Done
async function createUsers(count = 10000) {
    let data1 = [];
    const password = await bcrypt.hash('12345678', 1);
    for (let i = 0; i < count; i++) {
        const _id = faker.database.mongodbObjectId();
        const name = {
            first_name: faker.person.firstName(),
            last_name: faker.person.lastName()
        };
        const email = `user${i}_${faker.internet.email()}`;
        const phone = createPhoneNumber();
        const gender = faker.datatype.boolean() ? 'Male' : 'Female';
        const tempCountry = locations[Math.floor(Math.random() * locations.length)];
        const tempCity = tempCountry.cities[Math.floor(Math.random() * tempCountry.cities.length)];
        const location = {
            country: tempCountry.name,
            city: tempCity
        };
        const date_of_birth = faker.date.birthdate({ min: 18, max: 65, mode: 'age' });
        const profile_pic = '/images/default_profile.jpg';
        const data = {
            _id,
            name,
            email,
            phone,
            password,
            location,
            gender,
            date_of_birth,
            profile_pic
        };
        data1.push(data);
    }
    return await User.insertMany(data1);
}

// Done
function createPhoneNumber() {
    const countryNumber = numbers[Math.floor(Math.random() * numbers.length)];
    let length = countryNumber.phone_length;
    if (length == undefined) length = countryNumber.min;
    else if (length.length != undefined) length = length[0];
    return (number = {
        country_code: countryNumber.phone,
        number: faker.string.numeric(length)
    });
}

// Done (dont forget to return image)
async function createProducts() {
    const filePath = path.join(__dirname, '../public/json/filtered_data.csv');
    const products = [];

    return new Promise((resolve, reject) => {
        fs.createReadStream(filePath)
            .pipe(csv())
            .on('data', row => {
                // const folderNumber = '0' + String(row.article_id).slice(0, 2);
                // const imageNumber = '0' + row.article_id;
                // const imagePath = path.join(__dirname, '../public/images/products', folderNumber, `${imageNumber}.jpg`);

                // if (!fs.existsSync(imagePath)) return;

                const price = parseFloat(faker.commerce.price({ min: 10, max: 1000 }));
                const hasDiscount = Math.random() < 0.5;
                const discountAmount = faker.number.float({ min: 1, max: 20, multipleOf: 0.01 });
                let discounted_price = hasDiscount ? Math.max(price - discountAmount, 0) : price;
                discounted_price = parseFloat(discounted_price.toFixed(2));
                const createdAt = randomDatePastMonths(2);

                const product = {
                    name: row.prod_name?.trim(),
                    type: row.product_type_name?.trim(),
                    appearance: row.graphical_appearance_name?.trim(),
                    color: row.colour_group_name?.trim(),
                    department: row.department_name?.trim(),
                    gender: row.index_group_name?.trim(),
                    details: row.detail_desc?.trim() || faker.commerce.productDescription(),
                    price,
                    discounted_price,
                    quantity: faker.number.int({ min: 100, max: 3000 }),
                    // images: [`/images/products/${folderNumber}/${imageNumber}.jpg`],
                    images: [`/images/products/recomind1.jpg`],
                    createdAt,
                    updatedAt: createdAt
                };

                products.push(product);
            })
            .on('end', async () => {
                try {
                    await Product.insertMany(products);
                    console.log(`Inserted ${products.length} products (with existing images)`);
                    resolve();
                } catch (err) {
                    console.error('Error inserting products:', err);
                    reject(err);
                }
            })
            .on('error', err => {
                console.error('Error reading CSV file:', err);
                reject(err);
            });
    });
}

// done
async function updateAllProductAggregates() {
    console.log('Starting optimized update of all product aggregates using MongoDB aggregation...');
    const aggregationPipeline = [
        {
            $group: {
                _id: '$product_id',
                ratingSum: {
                    $sum: {
                        $cond: [
                            {
                                $and: [{ $eq: ['$interaction_type', 'rating'] }, { $isNumber: '$rating_value' }]
                            },
                            '$rating_value',
                            0
                        ]
                    }
                },
                ratingCount: {
                    $sum: {
                        $cond: [
                            {
                                $and: [{ $eq: ['$interaction_type', 'rating'] }, { $isNumber: '$rating_value' }]
                            },
                            1,
                            0
                        ]
                    }
                },
                viewsCount: {
                    $sum: { $cond: [{ $eq: ['$interaction_type', 'view'] }, 1, 0] }
                },
                favoritesCount: {
                    $sum: { $cond: [{ $eq: ['$interaction_type', 'favorite'] }, 1, 0] }
                },
                cartAddsCount: {
                    $sum: { $cond: [{ $eq: ['$interaction_type', 'add_to_cart'] }, 1, 0] }
                },
                ordersCount: {
                    $sum: { $cond: [{ $eq: ['$interaction_type', 'order'] }, 1, 0] }
                },
                totalProductInteractions: { $sum: 1 },
                totalInteractionScore: { $sum: { $ifNull: ['$interaction_weight', 0] } }
            }
        },
        {
            $project: {
                _id: 1,
                calculatedAverageRating: {
                    $cond: {
                        if: { $gt: ['$ratingCount', 0] },
                        then: { $round: [{ $divide: ['$ratingSum', '$ratingCount'] }, 2] },
                        else: 0
                    }
                },
                ratingCount: 1,
                viewsCount: 1,
                favoritesCount: 1,
                cartAddsCount: 1,
                ordersCount: 1,
                totalProductInteractions: 1,
                totalInteractionScore: 1
            }
        },
        {
            $merge: {
                into: 'products',
                on: '_id',
                let: {
                    agg_rating: '$calculatedAverageRating',
                    agg_rating_count: '$ratingCount',
                    agg_views: '$viewsCount',
                    agg_favorites: '$favoritesCount',
                    agg_add_to_cart: '$cartAddsCount',
                    agg_orders: '$ordersCount',
                    agg_total_interactions: '$totalProductInteractions',
                    agg_total_score: '$totalInteractionScore'
                },
                whenMatched: [
                    {
                        $set: {
                            rating: '$$agg_rating',
                            rating_count: '$$agg_rating_count',
                            'interactions.view': '$$agg_views',
                            'interactions.favorite': '$$agg_favorites',
                            'interactions.add_to_cart': '$$agg_add_to_cart',
                            'interactions.order': '$$agg_orders',
                            'interactions.total_interactions': '$$agg_total_interactions',
                            total_interaction_score: '$$agg_total_score',
                            updatedAt: new Date()
                        }
                    }
                ],
                whenNotMatched: 'discard'
            }
        }
    ];

    try {
        await Interaction.aggregate(aggregationPipeline).exec();
        console.log('Product aggregates update process completed using $merge.');
    } catch (error) {
        console.error('Error during optimized product aggregates update:', error);
        throw error;
    }
}

// done
async function createAdmins() {
    const admins = [{ username: 'ZYZZ', password: '12345678', role: 'Super-Admin' }];
    await Admins.create(admins);
}

// done
async function seedStatistics() {
    try {
        const users = await User.find({}, '_id').lean();
        if (!users.length) {
            console.log('No users found');
            return;
        }

        const chatbotTypes = ['text', 'image', 'text+image'];
        const recTypes = ['content', 'collaborative', 'hybrid'];

        const chatbotData = [];
        const recommendationData = [];

        for (const user of users) {
            const numberOfChatbotInteractions = Math.floor(Math.random() * 5) + 3;
            for (let i = 0; i < numberOfChatbotInteractions; i++) {
                const inputType = chatbotTypes[Math.floor(Math.random() * chatbotTypes.length)];

                const similarities = Array.from({ length: 5 }, () => +(Math.random() * 0.2 + 0.8).toFixed(3));
                const top1 = similarities[0];
                const avg = similarities.reduce((a, b) => a + b, 0) / similarities.length;
                const top3 = similarities.slice(0, 3);
                const top3_avg = top3.reduce((a, b) => a + b, 0) / top3.length;
                const response_time = +(Math.random() * 2 + 0.5).toFixed(3);

                chatbotData.push({
                    user_id: user._id,
                    input_type: inputType,
                    similarities,
                    similarity_metric: { top1, avg, top3_avg },
                    response_time,
                    createdAt: randomDatePast7Days(),
                    updatedAt: new Date()
                });
            }

            const numberOfRecInteractions = Math.floor(Math.random() * 5) + 3;
            for (let i = 0; i < numberOfRecInteractions; i++) {
                const recType = recTypes[Math.floor(Math.random() * recTypes.length)];

                const similarities = Array.from({ length: 5 }, () => +(Math.random() * 0.2 + 0.8).toFixed(3));
                const top1 = similarities[0];
                const avg = similarities.reduce((a, b) => a + b, 0) / similarities.length;
                const top3 = similarities.slice(0, 3);
                const top3_avg = top3.reduce((a, b) => a + b, 0) / top3.length;
                const response_time = +(Math.random() * 2 + 0.5).toFixed(3);

                recommendationData.push({
                    user_id: user._id,
                    rec_type: recType,
                    similarities,
                    similarity_metric: { top1, avg, top3_avg },
                    response_time,
                    createdAt: randomDatePast7Days(),
                    updatedAt: new Date()
                });
            }
        }

        if (chatbotData.length) {
            await ChatbotInteraction.insertMany(chatbotData);
            console.log(`Inserted ${chatbotData.length} chatbot interactions`);
        }

        if (recommendationData.length) {
            await RecommendationInteraction.insertMany(recommendationData);
            console.log(`Inserted ${recommendationData.length} recommendation interactions`);
        }

        console.log('Seeding completed successfully');
    } catch (err) {
        console.error('Error seeding statistics:', err);
    }
}

// done
function randomDatePast7Days() {
    const today = new Date();
    const past = new Date();
    past.setDate(today.getDate() - 7);
    return new Date(past.getTime() + Math.random() * (today.getTime() - past.getTime()));
}

// done
async function createNotifications(numNotifications = 1000) {
    try {
        const randomProducts = await Product.aggregate([{ $sample: { size: numNotifications } }]);

        const notifications = randomProducts.map(product => ({
            notification_title: 'Product Quantity is Low',
            notification_body: `${product.name}'s stock is about to finish. Only ${product.quantity} item(s) left.`
        }));

        await Notification.insertMany(notifications);
        console.log(`Created ${notifications.length} random notifications.`);
    } catch (err) {
        console.error('Error creating notifications:', err);
    }
}

// done
function randomDatePastMonths(months = 6) {
    const now = new Date();
    const past = new Date();
    past.setMonth(now.getMonth() - months);
    return new Date(past.getTime() + Math.random() * (now.getTime() - past.getTime()));
}

// done
async function createViewInteractions(totalInteractions = 2_000_000, batchSize = 50000, parallelLimit = 5) {
    const users = await User.find({}, '_id').lean();
    const products = await Product.find({}, '_id').lean();

    let batch = [];
    let promises = [];

    for (let i = 0; i < totalInteractions; i++) {
        const randomUser = faker.helpers.arrayElement(users);
        const randomProduct = faker.helpers.arrayElement(products);

        batch.push({
            user_id: randomUser._id,
            product_id: randomProduct._id,
            interaction_type: 'view',
            interaction_weight: WEIGHT_MAP['view'] || 0
        });

        if (batch.length >= batchSize) {
            promises.push(Interaction.insertMany(batch, { ordered: false }));
            batch = [];

            if (promises.length >= parallelLimit) {
                await Promise.all(promises);
                promises = [];
            }
        }
    }

    if (batch.length > 0) promises.push(Interaction.insertMany(batch, { ordered: false }));
    if (promises.length > 0) await Promise.all(promises);
}

///////////////////////////////////////////////////////////////////////////////////////

async function createFavorites(minFavoritesPerProduct = 10, maxFavoritesPerProduct = 35, batchSize = 5000) {
    const users = await User.find({}, '_id').lean();
    const products = await Product.find({}, '_id').lean();

    const favoritesData = [];
    const interactionsData = [];
    let batchCount = 0;

    for (const product of products) {
        const numFavorites = faker.number.int({ min: minFavoritesPerProduct, max: maxFavoritesPerProduct });
        const selectedUsers = faker.helpers.arrayElements(users, Math.min(numFavorites, users.length));

        for (const user of selectedUsers) {
            favoritesData.push({ user_id: user._id, products_id: [product._id] });
            interactionsData.push({
                user_id: user._id,
                product_id: product._id,
                interaction_type: 'favorite',
                interaction_weight: WEIGHT_MAP['favorite'] || 0
            });

            batchCount++;

            if (batchCount >= batchSize) {
                await Promise.all([Favorite.insertMany(favoritesData), Interaction.insertMany(interactionsData)]);
                favoritesData.length = 0;
                interactionsData.length = 0;
                batchCount = 0;
            }
        }
    }

    if (favoritesData.length > 0) {
        await Promise.all([Favorite.insertMany(favoritesData), Interaction.insertMany(interactionsData)]);
    }

    console.log('Favorites seeded successfully: each product has at least a few favorites.');
}

async function createOrders(numOrders = 5000, maxItemsPerOrder = 5, batchSize = 500) {
    const users = await User.find({}, '_id').lean();
    const products = await Product.find({}, '_id price discounted_price quantity').lean();

    if (!users.length || !products.length) {
        console.log('Need both users and products in database');
        return;
    }

    console.log(`Seeding ${numOrders} orders...`);

    let ordersData = [];

    for (let i = 0; i < numOrders; i++) {
        const randomUser = faker.helpers.arrayElement(users);
        const numItems = faker.number.int({ min: 1, max: maxItemsPerOrder });

        const selectedProducts = faker.helpers.arrayElements(products, numItems);

        const orderItems = selectedProducts.map(product => {
            const quantity = faker.number.int({ min: 1, max: 3 });
            const price = product.discounted_price || product.price;
            return { product: product._id, quantity, price };
        });

        const totalPrice = orderItems.reduce((sum, item) => sum + item.price * item.quantity, 0);

        const status = Math.random() < 0.7 ? 'prepare' : 'delivery';
        const createdAt = randomDatePastMonths(6);

        ordersData.push({
            user_id: randomUser._id,
            orderItems,
            total_price: parseFloat(totalPrice.toFixed(2)),
            status,
            createdAt,
            updatedAt: createdAt
        });

        if (ordersData.length >= batchSize) {
            await Order.insertMany(ordersData);
            ordersData = [];
        }
    }

    if (ordersData.length > 0) {
        await Order.insertMany(ordersData);
    }

    console.log(`Inserted ${numOrders} orders.`);
}

async function createCartsForAllUsers() {
    const users = await User.find({}, '_id');
    const products = await Product.find({}, '_id price');
    let carts = [];

    for (const user of users) {
        const itemCount = faker.number.int({ min: 1, max: 5 });

        let items = [];
        for (let j = 0; j < itemCount; j++) {
            const product = faker.helpers.arrayElement(products);
            const quantity = faker.number.int({ min: 1, max: 5 });

            items.push({
                product: product._id,
                quantity,
                price: product.price
            });
        }
        const total_price = items.reduce((sum, item) => sum + item.price * item.quantity, 0);

        carts.push({
            user_id: user._id,
            items,
            total_price
        });
    }

    return await Cart.insertMany(carts);
}

async function createCartInteractions() {
    const carts = await Cart.find().lean();

    if (!carts.length) {
        console.log('No carts found to create add_to_cart interactions.');
        return;
    }

    const interactionsData = [];

    for (const cart of carts) {
        for (const item of cart.items) {
            interactionsData.push({
                user_id: cart.user_id,
                product_id: item.product,
                interaction_type: 'add_to_cart',
                interaction_weight: WEIGHT_MAP['add_to_cart'] || 0
            });
        }
    }

    if (interactionsData.length > 0) {
        await Interaction.insertMany(interactionsData);
        console.log(`Created ${interactionsData.length} add_to_cart interactions.`);
    }
}

async function createOrderInteractions() {
    const orders = await Order.find().lean();

    if (!orders.length) {
        console.log('No orders found to create order interactions.');
        return;
    }

    const interactionsData = [];

    for (const order of orders) {
        for (const item of order.orderItems) {
            interactionsData.push({
                user_id: order.user_id,
                product_id: item.product,
                interaction_type: 'order',
                interaction_weight: WEIGHT_MAP['order'] || 0
            });
        }
    }

    if (interactionsData.length > 0) {
        await Interaction.insertMany(interactionsData);
        console.log(`Created ${interactionsData.length} order interactions.`);
    }
}

async function createRatingInteractions() {
    const orders = await Order.find().lean();

    if (!orders.length) {
        console.log('No orders found to create rating interactions.');
        return;
    }

    const interactionsData = [];

    for (const order of orders) {
        for (const item of order.orderItems) {
            if (Math.random() < 0.5) {
                const ratingValue = faker.number.int({ min: 1, max: 5 });

                interactionsData.push({
                    user_id: order.user_id,
                    product_id: item.product,
                    interaction_type: 'rating',
                    rating_value: ratingValue,
                    interaction_weight: ratingValue,
                    review_text: faker.lorem.sentence()
                });
            }
        }
    }

    if (interactionsData.length > 0) {
        await Interaction.insertMany(interactionsData);
        console.log(`Created ${interactionsData.length} rating interactions.`);
    }
}

async function createInteractions() {
    await createViewInteractions();
    console.log('View interactions created.');

    // await createFavorites();
    // console.log('Favorites created.');

    // await createCartInteractions();
    // console.log('Cart interactions created.');

    // await createOrderInteractions();
    // console.log('Order interactions created.');

    // await createRatingInteractions();
    // console.log('Rating interactions created.');
}

////////////////////////////////////////////////////////////////////////////////////

async function checkImagesFromCSV() {
    const filePath = path.join(__dirname, '../public/json/filtered_data.csv');

    let totalProducts = 0;
    let imagesFound = 0;
    let imagesMissing = 0;
    let missingPaths = [];

    return new Promise((resolve, reject) => {
        fs.createReadStream(filePath)
            .pipe(csv())
            .on('data', async row => {
                totalProducts++;

                const folderNumber = '0' + String(row.article_id).slice(0, 2);
                const imageNumber = '0' + row.article_id;
                const imagePath = path.join(__dirname, '../public/images/products', folderNumber, `${imageNumber}.jpg`);

                try {
                    await fsp.access(imagePath);
                    imagesFound++;
                } catch {
                    imagesMissing++;
                    missingPaths.push(imagePath);
                }
            })
            .on('end', () => {
                console.log('===== IMAGE CHECK REPORT =====');
                console.log(`Total products: ${totalProducts}`);
                console.log(`Images found: ${imagesFound}`);
                console.log(`Missing images: ${imagesMissing}`);

                if (missingPaths.length > 0) {
                    console.log('\n--- Missing image paths ---');
                    missingPaths.forEach(p => console.log(p));
                }

                resolve({ totalProducts, imagesFound, imagesMissing, missingPaths });
            })
            .on('error', err => {
                console.error('Error reading CSV file:', err);
                reject(err);
            });
    });
}

// if (require.main === module) {
//     checkImagesFromCSV().then(() => process.exit(0));
// }

module.exports = {
    createUsers,
    createProducts,
    createInteractions,
    updateAllProductAggregates,
    createAdmins,
    createFavorites,
    seedStatistics,
    createNotifications,
    createOrders,
    createCartsForAllUsers
};
