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
    createOrders
} = require('./seeding.generation');

async function seedDB() {
    await mongoConnect();

    console.log('Dropping Database');
    await dropDatabase();

    console.log('Seeding Database');

    console.log('Creating Users');
    await createUsers();

    console.log('Creating Products');
    await createProducts();

    console.log('Creating Interactions');
    await createInteractions();

    await updateAllProductAggregates();

    console.log('Creating Admins');
    await createAdmins();

    console.log('Creating Favorites');
    await createFavorites();

    console.log('Creating Statistics');
    await seedStatistics();

    console.log('Creating Notifications');
    await createNotifications();

    console.log('Creating Orders');
    await createOrders();

    console.log('Database seeded!');
    await mongoDisconnect();
}

seedDB().catch(err => console.log(err));
