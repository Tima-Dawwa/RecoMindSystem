const schedule = require('node-schedule');
const { getLowQuantityProducts } = require('../models/products.model');
const { addNotification } = require('../routes/Dashboard/Notifications/notifications.helper');

schedule.scheduleJob('0 3 * * *', async () => {
    // Runs every day at 3:00 AM
    try {
        console.log('Starting ALS model retrain at 3 AM...');
        const response = await axios.post("http://127.0.0.1:8000/collaborative-recommendations");
        console.log('Retrain response:', response.data);
    } catch (error) {
        console.error('Error calling retrain route:', error.message);
    }
});

schedule.scheduleJob('/10 * * * *', async () => {
    const lowProducts = await getLowQuantityProducts();
    lowProducts.forEach(async product => {
        await addNotification(product)
    })
});