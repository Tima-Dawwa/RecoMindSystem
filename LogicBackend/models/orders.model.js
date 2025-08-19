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
    return await Order.findById(order_id);
}


async function getUniqueUsersCount() {
    return await Order.distinct('user_id').countDocuments();
}

async function getTotalProfit() {
    const orders = await Order.find();
    let totalProfit = 0;

    for (const order of orders) {
        const productsCount = order.orderItems.length;
        const orderProfit = productsCount * 2; // $2 profit per product
        totalProfit += orderProfit;
    }

    return totalProfit;
}

async function getAllOrdersWithUserDetails(skip = 0, limit = 10, searchUsername = null, searchDate = null) {
    let query = {};

    if (searchDate) {
        const startOfDay = new Date(searchDate);
        startOfDay.setHours(0, 0, 0, 0);
        const endOfDay = new Date(searchDate);
        endOfDay.setHours(23, 59, 59, 999);
        query.createdAt = { $gte: startOfDay, $lte: endOfDay };
    }

    const orders = await Order.find(query)
        .populate('user_id', 'username')
        .sort({ createdAt: -1 })
        .skip(skip)
        .limit(limit);

    let filteredOrders = orders;
    if (searchUsername) {
        filteredOrders = orders.filter(order =>
            order.user_id &&
            order.user_id.username &&
            order.user_id.username.toLowerCase().includes(searchUsername.toLowerCase())
        );
    }

    return filteredOrders.map(order => ({
        id: order._id,
        username: order.user_id ? order.user_id.username : 'Unknown',
        order_date: order.createdAt,
        status: order.status,
        products_count: order.orderItems.length,
        total_price: order.total_price
    }));
}

async function getTrendingProductIds(threshold = 10, withinDays = 3) {
    const fromDate = new Date();
    fromDate.setDate(fromDate.getDate() - withinDays);

    const orders = await Order.find({ createdAt: { $gte: fromDate } }).select('orderItems');

    const salesMap = {};
    for (const order of orders) {
        for (const item of order.orderItems) {
            const id = item.product.toString();
            salesMap[id] = (salesMap[id] || 0) + (item.quantity || 1);
        }
    }

    return Object.entries(salesMap)
        .filter(([_, count]) => count > threshold)
        .map(([id]) => id);
}

async function updateOrderStatus(orderId, newStatus) {
    if (!['breaber', 'delevery'].includes(newStatus)) {
        throw new Error('Invalid status. Must be either "breaber" or "delevery"');
    }

    return await Order.findByIdAndUpdate(
        orderId,
        { status: newStatus },
        { new: true, runValidators: true }
    );
}

async function createOrder(orderData) {
    const order = new Order(orderData);
    return await order.save();
}

module.exports = {
    getOrdersForUser,
    getOrders,
    getOrder,
    getOrdersCountForUser,
    getOrdersCount,
    getTrendingProductIds,
    getUniqueUsersCount,
    getTotalProfit,
    getAllOrdersWithUserDetails,
    updateOrderStatus,
    createOrder
}