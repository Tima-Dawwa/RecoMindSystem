const { validatePostNotification } = require('./notifications.validation')
const { postNotification } = require('../../../models/notifications.model')


async function addNotification(product) {
    const data = {
        notification_title: "Product Quantity is Low",
        notification_body: `${product.name}'s stock is about to finish. Only ${product.quantity} item(s) left.`,
    };
    const { error } = validatePostNotification(data)
    if (error) return

    await postNotification(data);
}

module.exports = {
    addNotification
}