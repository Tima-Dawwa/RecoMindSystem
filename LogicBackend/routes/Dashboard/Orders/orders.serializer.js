function orderData(order) {
    return {
        id: order._id,
        user_id: order.user_id,
        orderItems: order.orderItems,
        total_price: order.total_price,
        status: order.status,
        created_at: order.createdAt,
        updated_at: order.updatedAt
    };
}

module.exports = {
    orderData
};
