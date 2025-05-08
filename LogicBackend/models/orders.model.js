const Order = require('./orders.mongo');

async function getOrdersForUser(user_id, skip, limit) {
    return await Order.find({ user_id }).skip(skip).limit(limit);
}

async function getOrdersCountForUser(user_id) {
    return await Order.find({ user_id }).countDocuments();
}

async function getOrdersCount() {
    return await Order.find().countDocuments();
}

async function getOrders(user_id, skip, limit) {
    return await Order.find().skip(skip).limit(limit);
}

async function getOrder(order_id) {
    return await Order.findById(order_id)
}

module.exports = {
    getOrdersForUser,
    getOrders,
    getOrder,
    getOrdersCountForUser,
    getOrdersCount
}
