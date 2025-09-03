const Order = require('./orders.mongo');

async function getOrdersForUser(user_id, skip, limit, sortBy = 'createdAt', sortOrder = 'desc') {
    let sortQuery = {};

    const validSortFields = ['createdAt', 'total_price', 'status'];
    if (!validSortFields.includes(sortBy)) {
        sortBy = 'createdAt';
    }

    if (sortOrder !== 'asc' && sortOrder !== 'desc') {
        sortOrder = 'desc';
    }

    sortQuery[sortBy] = sortOrder === 'desc' ? -1 : 1;

    return await Order.find({ user_id }).sort(sortQuery).skip(skip).limit(limit);
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
        const orderProfit = order.total_price * 0.2;
        totalProfit += orderProfit;
    }

    return Math.round(totalProfit * 100) / 100;
}

async function getAllOrdersWithUserDetails(skip = 0, limit = 10, searchUsername = null, searchDate = null, sortBy = 'createdAt', sortOrder = 'desc') {
    let query = {};

    if (searchDate) {
        const startOfDay = new Date(searchDate);
        startOfDay.setHours(0, 0, 0, 0);
        const endOfDay = new Date(searchDate);
        endOfDay.setHours(23, 59, 59, 999);
        query.createdAt = { $gte: startOfDay, $lte: endOfDay };
    }

    if (searchUsername) {
        const User = require('./users.mongo');
        const matchingUsers = await User.find({
            username: { $regex: searchUsername, $options: 'i' }
        }).select('_id');
        const userIds = matchingUsers.map(user => user._id);
        query.user_id = { $in: userIds };
    }

    const validSortFields = ['createdAt', 'total_price', 'status', 'username'];
    if (!validSortFields.includes(sortBy)) {
        sortBy = 'createdAt';
    }

    if (sortOrder !== 'asc' && sortOrder !== 'desc') {
        sortOrder = 'desc';
    }

    let sortQuery = {};
    if (sortBy === 'username') {
        sortQuery = { createdAt: -1 };
    } else {
        sortQuery[sortBy] = sortOrder === 'desc' ? -1 : 1;
    }

    const orders = await Order.find(query).populate('user_id', 'name').sort(sortQuery).skip(skip).limit(limit);

    let result = orders.map(order => ({
        id: order._id,
        username: order.user_id ? `${order.user_id.name.first_name} ${order.user_id.name.last_name}` : 'Unknown',
        order_date: order.createdAt,
        status: order.status,
        products_count: order.orderItems.length,
        total_price: order.total_price
    }));

    if (sortBy === 'username') {
        result.sort((a, b) => {
            const aUsername = a.username.toLowerCase();
            const bUsername = b.username.toLowerCase();
            if (sortOrder === 'asc') {
                return aUsername.localeCompare(bUsername);
            } else {
                return bUsername.localeCompare(aUsername);
            }
        });
    }

    return result;
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
    if (!['prepare', 'delivery'].includes(newStatus)) {
        throw new Error('Invalid status. Must be either "prepare" or "delivery"');
    }

    return await Order.findByIdAndUpdate(orderId, { status: newStatus }, { new: true, runValidators: true });
}

async function createOrder(orderData) {
    const order = new Order(orderData);
    return await order.save();
}

async function getLast12MonthsSales() {
    const endDate = new Date();
    const startDate = new Date();
    startDate.setMonth(endDate.getMonth() - 11);
    startDate.setDate(1);

    const pipeline = [
        {
            $match: {
                createdAt: { $gte: startDate, $lte: endDate }
            }
        },
        {
            $group: {
                _id: { $dateToString: { format: '%Y-%m', date: '$createdAt' } },
                totalSales: { $sum: '$total_price' },
                orderCount: { $sum: 1 }
            }
        },
        { $sort: { _id: 1 } }
    ];

    const results = await Order.aggregate(pipeline);

    const months = [];
    const date = new Date(startDate);
    for (let i = 0; i < 12; i++) {
        const key = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}`;
        months.push(key);
        date.setMonth(date.getMonth() + 1);
    }

    const salesMap = results.reduce((acc, item) => {
        acc[item._id] = { totalSales: item.totalSales, orderCount: item.orderCount };
        return acc;
    }, {});

    const finalResult = months.map(month => {
        return {
            month,
            totalSales: salesMap[month]?.totalSales || 0,
            orderCount: salesMap[month]?.orderCount || 0
        };
    });

    return finalResult;
}

async function getTopCustomersByOrders(limit = 10) {
    const pipeline = [
        {
            $group: {
                _id: '$user_id',
                order_count: { $sum: 1 },
                total_spent: { $sum: '$total_price' }
            }
        },
        { $sort: { order_count: -1 } },
        { $limit: limit },
        {
            $lookup: {
                from: 'users',
                localField: '_id',
                foreignField: '_id',
                as: 'user'
            }
        },
        { $unwind: '$user' },
        {
            $project: {
                _id: 0,
                full_name: {
                    $concat: ['$user.name.first_name', ' ', '$user.name.last_name']
                },
                order_count: 1,
                total_spent: 1
            }
        }
    ];

    return await Order.aggregate(pipeline);
}

async function getOrderWithPopulate(id) {
    return await Order.findById(id).populate('orderItems.product');
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
    createOrder,
    getLast12MonthsSales,
    getTopCustomersByOrders,
    getOrderWithPopulate
};
