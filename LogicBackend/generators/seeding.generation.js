const { faker } = require('@faker-js/faker')
const User = require('../models/users.mongo')
const Product = require('../models/products.mongo')
const bcrypt = require('bcryptjs');
const locations = require('../public/json/countries-all.json')
const numbers = require('../public/json/phone_number.json')
const fs = require('fs');
const path = require('path');
const csv = require('csv-parser');
const Interaction = require('../models/interactions.mongo');

// Done
async function createUsers(count = 1000) {
    let data1 = []
    const password = await bcrypt.hash('12345678', 1);
    for (let i = 0; i < count; i++) {
        const _id = faker.database.mongodbObjectId()
        const name = {
            first_name: faker.person.firstName(),
            last_name: faker.person.lastName(),
        }
        const email = faker.internet.email()
        const phone = createPhoneNumber()
        const gender = faker.datatype.boolean() ? 'Male' : 'Female'
        const tempCountry = locations[Math.floor(Math.random() * locations.length)]
        const tempCity = tempCountry.cities[Math.floor(Math.random() * tempCountry.cities.length)]
        const location = {
            country: tempCountry.name,
            city: tempCity
        }
        const date_of_birth = faker.date.birthdate({ min: 18, max: 65, mode: 'age' })
        const data = {
            _id,
            name,
            email,
            phone,
            password,
            location,
            gender,
            date_of_birth
        }
        data1.push(data)
    }
    return await User.insertMany(data1)
}

// Done
function createPhoneNumber() {
    const countryNumber = numbers[Math.floor(Math.random() * numbers.length)]
    let length = countryNumber.phone_length
    if (length == undefined) length = countryNumber.min
    else if (length.length != undefined) length = length[0]
    return number = {
        country_code: countryNumber.phone,
        number: faker.string.numeric(length)
    }
}

async function createProducts() {
    const filePath = path.join(__dirname, '../public/json/filtered_data.csv');
    const products = [];

    return new Promise((resolve, reject) => {
        fs.createReadStream(filePath)
            .pipe(csv())
            .on('data', (row) => {
                const price = parseFloat(faker.commerce.price({ min: 10, max: 300 }));
                const hasDiscount = Math.random() < 0.5;
                const discountAmount = faker.number.float({ min: 1, max: 20, multipleOf: 0.01 });
                const discounted_price = hasDiscount ? Math.max(price - discountAmount, 0) : price;
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
                    quantity: faker.number.int({ min: 0, max: 100 }),
                    images: row.images ? row.images.split('|').map(img => img.trim()) : []
                };
                products.push(product);
            })
            .on('end', async () => {
                try {
                    await Product.insertMany(products);
                    console.log(`✅ Inserted ${products.length} products`);
                    resolve();
                } catch (err) {
                    console.error('❌ Error inserting products:', err);
                    reject(err);
                }
            })
            .on('error', (err) => {
                console.error('❌ Error reading CSV file:', err);
                reject(err);
            });
    });
}

async function createInteractions(count = 1000000) {
    const users = await User.find({}, '_id').lean();
    const products = await Product.find({}, '_id').lean();
    const interactionTypes = ['view', 'add_to_cart', 'favorite', 'order', 'rating'];
    const interactionData = [];
    const weightMap = {
        view: 1,
        favorite: 2,
        add_to_cart: 3,
        order: 5,
    };
    for (let i = 0; i < count; i++) {
        const randomUser = users[Math.floor(Math.random() * users.length)];
        const randomProduct = products[Math.floor(Math.random() * products.length)];
        const interactionType = interactionTypes[Math.floor(Math.random() * interactionTypes.length)];
        let interaction = {
            user_id: randomUser._id,
            product_id: randomProduct._id,
            interaction_type: interactionType,
        };
        if (interactionType == 'rating') {
            interaction.rating_value = faker.number.int({ min: 1, max: 5 })
            interaction.interaction_weight = interaction.rating_value
        } else {
            interaction.interaction_weight = weightMap[interactionType]
        }

        interactionData.push(interaction);
    }
    await Interaction.insertMany(interactionData);
}

async function updateAllProductAggregates() {
    console.log('🚀 Starting optimized update of all product aggregates using MongoDB aggregation...');
    const aggregationPipeline = [
        {
            // Stage 1: Group interactions by product_id and calculate initial aggregates
            $group: {
                _id: "$product_id", // Group by the product ID
                ratingSum: {
                    $sum: { // Sum rating_value only for 'rating' interactions with a valid number
                        $cond: [
                            {
                                $and: [
                                    { $eq: ["$interaction_type", "rating"] }, // Ensure this matches your schema/data
                                    { $isNumber: "$rating_value" }
                                ]
                            },
                            "$rating_value",
                            0
                        ]
                    }
                },
                ratingCount: {
                    $sum: { // Count 'rating' interactions with a valid number
                        $cond: [
                            {
                                $and: [
                                    { $eq: ["$interaction_type", "rating"] },
                                    { $isNumber: "$rating_value" }
                                ]
                            },
                            1,
                            0
                        ]
                    }
                },
                viewsCount: {
                    $sum: { $cond: [{ $eq: ["$interaction_type", "view"] }, 1, 0] }
                },
                favoritesCount: {
                    $sum: { $cond: [{ $eq: ["$interaction_type", "favorite"] }, 1, 0] }
                },
                cartAddsCount: {
                    $sum: { $cond: [{ $eq: ["$interaction_type", "add_to_cart"] }, 1, 0] }
                },
                ordersCount: {
                    $sum: { $cond: [{ $eq: ["$interaction_type", "order"] }, 1, 0] }
                },
                totalProductInteractions: { $sum: 1 }, // Total number of interactions for this product
                totalInteractionScore: { $sum: { $ifNull: ["$interaction_weight", 0] } } // Sum existing weights
            }
        },
        {
            // Stage 2: Project the final fields, including calculated averageRating
            $project: {
                _id: 1, // This is the product_id, crucial for $merge
                calculatedAverageRating: {
                    $cond: {
                        if: { $gt: ["$ratingCount", 0] },
                        then: { $round: [{ $divide: ["$ratingSum", "$ratingCount"] }, 2] }, // Round to 2 decimal places
                        else: 0 // Default to 0 if no ratings
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
            // Stage 3: Merge the results into the 'products' collection (MongoDB 4.2+)
            $merge: {
                into: "products", // The target collection name (Mongoose usually pluralizes model names)
                on: "_id",        // Match documents in "products" where its _id equals the _id from this pipeline
                let: {            // Define variables from the current aggregated document for use in the update
                    agg_rating: "$calculatedAverageRating",
                    agg_rating_count: "$ratingCount",
                    agg_views: "$viewsCount",
                    agg_favorites: "$favoritesCount",
                    agg_add_to_cart: "$cartAddsCount",
                    agg_orders: "$ordersCount",
                    agg_total_interactions: "$totalProductInteractions",
                    agg_total_score: "$totalInteractionScore"
                },
                whenMatched: [ // Pipeline to execute when a product is matched
                    {
                        $set: { // Update these fields on the matched product
                            rating: "$$agg_rating",
                            rating_count: "$$agg_rating_count",
                            "interactions.views": "$$agg_views",
                            "interactions.favorites": "$$agg_favorites",
                            "interactions.add_to_cart": "$$agg_add_to_cart",
                            "interactions.orders": "$$agg_orders",
                            "interactions.total_interactions": "$$agg_total_interactions",
                            total_interaction_score: "$$agg_total_score",
                            updatedAt: new Date() // Manually set updatedAt if not using schema timestamps for this operation
                        }
                    }
                ],
                whenNotMatched: "discard" // If an interaction's product_id doesn't exist in Products, do nothing
            }
        }
    ];

    try {
        // Execute the aggregation pipeline.
        // The $merge stage writes directly to the 'products' collection and does not return documents to the client.
        await Interaction.aggregate(aggregationPipeline).exec();

        console.log('✅ Product aggregates update process completed using $merge.');
        // Note: $merge doesn't directly return a count of updated documents to the client.
        // You would verify the updates by querying the Product collection afterwards.
    } catch (error) {
        console.error('❌ Error during optimized product aggregates update:', error);
        // Consider re-throwing or more specific error handling
        throw error;
    }
}


// async function createNotifications() {
//     let data = []
//     for (let i = 0; i < 3000; i++) {
//         const temp = {
//             notification_title: faker.word.words({ count: { min: 2, max: 4 } }),
//             notification_body: faker.lorem.lines({ min: 1, max: 3 }),
//             is_global: true,
//             createdAt: faker.date.between({ from: '2020-01-01T00:00:00.000Z', to: '2024-08-14T00:00:00.000Z' })
//         }
//         data.push(temp)
//     }
//     await Notification.insertMany(data)
// }

module.exports = {
    createUsers,
    createProducts,
    createInteractions,
    updateAllProductAggregates
    // createNotifications
}