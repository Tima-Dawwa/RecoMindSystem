const { mongoConnect, mongoDisconnect, dropDatabase } = require('../services/mongo');
const { createUsers, createProducts, createInteractions, updateAllProductAggregates } = require('./seeding.generation');

async function seedDB() {
    await mongoConnect();

    // Delete All Tables
    // console.log('Dropping Database')
    // await dropDatabase()

    // console.log('Seeding Database');

    // await createUsers()

    // await createProducts()

    // await createInteractions()

    // await updateAllProductAggregates()

    console.log('Database seeded!');

    await mongoDisconnect()
}

seedDB().catch(err => console.log(err));
