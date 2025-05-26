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

async function getTrendingProductIds(threshold = 10, withinDays = 3) {
    const fromDate = new Date();
    fromDate.setDate(fromDate.getDate() - withinDays);

    const orders = await Order.find({ createdAt: { $gte: fromDate } }).select('products_id');

    const salesMap = {};
    for (const order of orders) {
        for (const prodId of order.products_id) {
            const id = prodId.toString();
            salesMap[id] = (salesMap[id] || 0) + 1;
        }
    }

    return Object.entries(salesMap)
        .filter(([_, count]) => count > threshold)
        .map(([id]) => id);
}

module.exports = {
    getOrdersForUser,
    getOrders,
    getOrder,
    getOrdersCountForUser,
    getOrdersCount,
    getTrendingProductIds
}
