const { mongoConnect, mongoDisconnect, dropDatabase } = require('../services/mongo');
const { createUsers, createProducts, createInteractions, updateAllProductAggregates, createAdmins, createFavorites, seedStatistics } = require('./seeding.generation');

async function seedDB() {
    await mongoConnect();

    console.log('Dropping Database');
    await dropDatabase();

    console.log('Seeding Database');

    console.log('Creating Users');
    await createUsers();

    console.log('Creating Products');
    await createProducts();

    await createInteractions();

    await updateAllProductAggregates();

    console.log('Creating Admins');
    await createAdmins();

    console.log('Creating Favorites');
    await createFavorites();

    console.log('Seeding Statistics');
    await seedStatistics();

    console.log('Database seeded!');

    await mongoDisconnect();
}

seedDB().catch(err => console.log(err));
