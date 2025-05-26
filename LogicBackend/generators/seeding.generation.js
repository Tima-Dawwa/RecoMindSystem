const { faker } = require('@faker-js/faker')
const User = require('../models/users.mongo')
const Product = require('../models/products.mongo')
const bcrypt = require('bcryptjs');
const locations = require('../public/json/countries-all.json')
const numbers = require('../public/json/phone_number.json')
const fs = require('fs');
const path = require('path');
const csv = require('csv-parser');

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
                    rating: faker.number.float({ min: 0, max: 5, multipleOf: 0.1 }),
                    rating_count: faker.number.int({ min: 0, max: 500 }),
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

async function createInteractions(count = 100000) {
    const users = await User.find({}, '_id').lean();
    const products = await Product.find({}, '_id').lean();
    const interactionTypes = ['view', 'add_to_cart', 'favorite', 'order'];
    const interactionData = [];

    for (let i = 0; i < count; i++) {
        const randomUser = users[Math.floor(Math.random() * users.length)];
        const randomProduct = products[Math.floor(Math.random() * products.length)];
        const interactionType = interactionTypes[Math.floor(Math.random() * interactionTypes.length)];

        const interaction = {
            user_id: randomUser._id,
            product_id: randomProduct._id,
            interaction_type: interactionType
        };

        interactionData.push(interaction);
    }
    await Interaction.insertMany(interactionData);
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
    createInteractions
    // createNotifications
}