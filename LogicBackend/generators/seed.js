const { mongoConnect, mongoDisconnect, dropDatabase } = require('../services/mongo');
const {
    createUsers,
    createProducts,
    createInteractions,
    updateAllProductAggregates,
    createNotifications,
    createAdmins,
    createFavorites,
    seedStatistics,
    createOrders,
    createCartsForAllUsers
} = require('./seeding.generation');

async function seedDB() {
    console.time('Total Seeding Time');
    await mongoConnect();

    console.log('Dropping Database');
    console.time('Drop Database');
    await dropDatabase();
    console.timeEnd('Drop Database');

    console.log('Seeding Database');

    console.log('Creating Admins');
    console.time('Create Admins');
    await createAdmins();
    console.timeEnd('Create Admins');

    console.log('Creating Users');
    console.time('Create Users');
    await createUsers();
    console.timeEnd('Create Users');

    console.log('Creating Products');
    console.time('Create Products');
    await createProducts();
    console.timeEnd('Create Products');

    console.log('Creating Carts');
    console.time('Create Carts');
    await createCartsForAllUsers();
    console.timeEnd('Create Carts');

    console.log('Creating Orders');
    console.time('Create Orders');
    await createOrders();
    console.timeEnd('Create Orders');

    console.log('Creating Favorites and Interactions');
    console.time('Create Favorites & Interactions');
    await createFavorites();
    console.timeEnd('Create Favorites & Interactions');

    console.log('Creating Other Interactions');
    console.time('Create Other Interactions');
    await createInteractions();
    console.timeEnd('Create Other Interactions');

    console.log('Updating Product Aggregates');
    console.time('Update Product Aggregates');
    await updateAllProductAggregates();
    console.timeEnd('Update Product Aggregates');

    console.log('Creating Notifications');
    console.time('Create Notifications');
    await createNotifications();
    console.timeEnd('Create Notifications');

    console.log('Seeding Statistics');
    console.time('Seed Statistics');
    await seedStatistics();
    console.timeEnd('Seed Statistics');

    console.log('Database seeded!');
    await mongoDisconnect();
    console.timeEnd('Total Seeding Time');
}

seedDB().catch(err => console.log(err));
