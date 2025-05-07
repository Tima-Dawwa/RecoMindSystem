const Order = require('./orders.mongo');

async function getOrders(user_id, skip, limit) {
    return await Order.find({ user_id }).skip(skip).limit(limit);
}

async function getOrder(order_id) {
    return await Order.findById(order_id)
}

module.exports = {
    getOrders,
    getOrder,
}
