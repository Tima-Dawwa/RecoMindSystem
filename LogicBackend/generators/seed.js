const { mongoConnect, mongoDisconnect, dropDatabase } = require('../services/mongo');
const { createUsers, createProducts, createInteractions, updateAllProductAggregates, createAdmins, createFavorites } = require('./seeding.generation');

async function seedDB() {
    await mongoConnect();

    // Delete All Tables
    console.log('Dropping Database')
    await dropDatabase()

    console.log('Seeding Database');

    console.log('Creating Users');
    await createUsers()

    console.log('Creating Products');
    await createProducts()

    await createInteractions()

    await updateAllProductAggregates()

    console.log('Creating Admins');
    await createAdmins()

    console.log('Creating Favorites');
    await createFavorites()

    console.log('Database seeded!');

    await mongoDisconnect()
}

seedDB().catch(err => console.log(err));
