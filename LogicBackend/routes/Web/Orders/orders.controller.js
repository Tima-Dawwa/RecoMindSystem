const { getCart, resetCart } = require('../../../models/cart.model');
const { getOrdersForUser, getOrder, getOrdersCountForUser } = require('../../../models/orders.model');
const { getPagination } = require('../../../services/query');
const { getProductsByIds } = require('../../../models/products.model');
const { createPaymentData } = require('../../../services/payment');
const { paymentSheet } = require('../Payments/payments.controller')
const { postInteraction } = require('../../../models/interactions.model');
const { INTERACTION_TYPES } = require('../../../public/constants/interaction');
const { incrementInteractionCount } = require('../../../models/products.model');

async function httpGetOrders(req, res) {
    const { skip, limit } = getPagination(req.query);
    const data = await getOrdersForUser(req.user.id, skip, limit);
    const orders = data.map((order, idx) => ({
        order_number: skip + idx + 1,
        order_id: order._id,
        products_count: order.orderItems.length,
        total_price: order.total_price,
        created_at: order.createdAt,
        status: order.status
    }));
    const count = orders.length;
    return res.status(200).json({ data: orders, count });
}

async function httpGetOrder(req, res) {
    const order = await getOrder(req.params.id);
    if (!order) return res.status(404).json({ message: "Order Not Found" });

    const productIds = order.orderItems.map(item => item.product);
    const products = await getProductsByIds(productIds);

    const productsDetails = order.orderItems.map(item => {
        const product = products.find(p => p._id.toString() === item.product.toString());
        return {
            id: item.product,
            name: product ? product.name : undefined,
            price: item.price,
            discounted_price: product ? product.discounted_price : undefined,
            department: product ? product.department : undefined,
            image: product && product.images ? product.images[0] : undefined,
            quantity: item.quantity
        };
    });
    const orderDetails = {
        order_id: order._id,
        products_count: order.orderItems.length,
        total_price: order.total_price,
        created_at: order.createdAt,
        status: order.status,
        products: productsDetails
    };
    return res.status(200).json({ data: orderDetails });
}

async function httpPostOrder(req, res) {
    const cart = await getCart(req.user._id)
    if (!cart) return res.status(404).json({ message: "No Cart Found" })

    for (let i = 0; i < cart.items.length; i++) {
        await postInteraction(req.user._id, cart.items[i].product._id, INTERACTION_TYPES.ORDER)
        await incrementInteractionCount(req.params.id, INTERACTION_TYPES.FAVORITE)
    }
    await resetCart(req.user._id)

    req.body.data = createPaymentData(cart);
    paymentSheet(req, res)
}

module.exports = {
    httpGetOrders,
    httpGetOrder,
    httpPostOrder
}