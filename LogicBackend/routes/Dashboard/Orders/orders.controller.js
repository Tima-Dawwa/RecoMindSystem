const {
    getOrders,
    getOrder,
    getOrdersCount,
    getUniqueUsersCount,
    getTotalProfit,
    getAllOrdersWithUserDetails,
    updateOrderStatus
} = require('../../../models/orders.model');
const { getPagination } = require('../../../services/query');
const { serializedData } = require('../../../services/serializeArray');
const { orderData } = require('./orders.serializer');

async function httpGetOrders(req, res) {
    const { skip, limit } = getPagination(req.query);
    const { username, date, sortBy = 'createdAt', sortOrder = 'desc' } = req.query;

    const data = await getAllOrdersWithUserDetails(skip, limit, username, date, sortBy, sortOrder);
    const count = await getOrdersCount();

    return res.status(200).json({ data, count });
}

async function httpGetOrder(req, res) {
    const data = await getOrder(req.params.id);
    if (!data) return res.status(404).json({ message: "Order Not Found" });
    return res.status(200).json({ data: orderData(data) });
}

async function httpGetOrdersStatistics(req, res) {
    try {
        const [totalOrders, uniqueUsers, totalProfit] = await Promise.all([
            getOrdersCount(),
            getUniqueUsersCount(),
            getTotalProfit()
        ]);

        return res.status(200).json({
            data: {
                total_orders: totalOrders,
                unique_users: uniqueUsers,
                total_profit: totalProfit
            }
        });
    } catch (error) {
        return res.status(500).json({ message: "Error fetching statistics", error: error.message });
    }
}

async function httpUpdateOrderStatus(req, res) {
    try {
        const { orderId } = req.params;
        const { status } = req.body;

        if (!status || !['prepare', 'delivery'].includes(status)) {
            return res.status(400).json({
                message: "Invalid status. Must be either 'prepare' or 'delivery'"
            });
        }

        const updatedOrder = await updateOrderStatus(orderId, status);

        if (!updatedOrder) {
            return res.status(404).json({ message: "Order not found" });
        }

        return res.status(200).json({
            message: "Order status updated successfully",
            data: {
                id: updatedOrder._id,
                status: updatedOrder.status
            }
        });
    } catch (error) {
        return res.status(500).json({
            message: "Error updating order status",
            error: error.message
        });
    }
}

module.exports = {
    httpGetOrders,
    httpGetOrder,
    httpGetOrdersStatistics,
    httpUpdateOrderStatus
}