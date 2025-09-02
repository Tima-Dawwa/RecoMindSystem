const { resetCart } = require('../../../models/cart.model');
const { getOrdersForUser, getOrder, createOrder, getOrdersCountForUser, getOrderWithPopulate } = require('../../../models/orders.model');
const { getPagination } = require('../../../services/query');
const { getProductsByIds, decrementQuantity } = require('../../../models/products.model');
const { createPaymentData } = require('../../../services/payment');
const { paymentSheet } = require('../Payments/payments.controller');
const { postInteraction } = require('../../../models/interactions.model');
const { INTERACTION_TYPES } = require('../../../public/constants/interaction');
const { incrementInteractionCount } = require('../../../models/products.model');
const { validatePostOrder } = require('./orders.validation');
const productsMongo = require('../../../models/products.mongo');
const { validationErrors } = require('../../../middlewares/validationErrors');

async function httpGetOrders(req, res) {
    const { skip, limit } = getPagination(req.query);
    const { sortBy = 'createdAt', sortOrder = 'desc' } = req.query;

    const data = await getOrdersForUser(req.user.id, skip, limit, sortBy, sortOrder);
    const orders = data.map((order, idx) => {
        const products_count = order.orderItems.reduce((sum, item) => sum + (item.quantity || 0), 0);
        return {
            order_number: skip + idx + 1,
            order_id: order._id,
            products_count: products_count,
            total_price: order.total_price,
            created_at: order.createdAt,
            status: order.status
        };
    });
    const count = await getOrdersCountForUser(req.user.id);
    return res.status(200).json({ data: orders, count });
}

async function httpGetOrder(req, res) {
    const order = await getOrder(req.params.id);
    if (!order) return res.status(404).json({ message: 'Order Not Found' });

    const productIds = order.orderItems.map(item => item.product);
    const products = await getProductsByIds(productIds);

    const productsDetails = order.orderItems.map(item => {
        const product = products.find(p => p._id.toString() === item.product.toString());
        return {
            id: item.product,
            name: product ? product.name : undefined,
            price: item.price,
            discounted_price: product ? product.discounted_price : undefined,
            department: product ? product.department || product.category : undefined,
            image: product && product.images ? product.images[0] : undefined,
            quantity: item.quantity
        };
    });
    const orderDetails = {
        order_id: order._id,
        products_count: order.orderItems.reduce((sum, item) => sum + (item.quantity || 0), 0),
        total_price: order.total_price,
        created_at: order.createdAt,
        status: order.status,
        products: productsDetails
    };
    return res.status(200).json({ data: orderDetails });
}

async function httpPostOrder(req, res) {
    const { error } = validatePostOrder(req.body);
    if (error) {
        return res.status(400).json({
            errors: validationErrors(error.details)
        });
    }
    let cart = req.body;

    const orderData = {
        user_id: req.user._id,
        orderItems: cart.items,
        total_price: cart.total_price,
        status: 'prepare'
    };
    const order = await createOrder(orderData);

    for (let i = 0; i < cart.items.length; i++) {
        const item = cart.items[i];
        const product = await productsMongo.findById(item.product);

        if (!product) {
            return res.status(404).json({ message: `Product not found: ${item.product}` });
        }

        if (product.quantity < item.quantity) {
            return res.status(400).json({
                message: `Insufficient stock for "${product.name}". Available: ${product.quantity}, Requested: ${item.quantity}`
            });
        }
    }

    for (let i = 0; i < cart.items.length; i++) {
        await decrementQuantity(cart.items[i].product, cart.items[i].quantity);
        await postInteraction(req.user._id, cart.items[i].product, INTERACTION_TYPES.ORDER);
        await incrementInteractionCount(cart.items[i].product, INTERACTION_TYPES.FAVORITE);
    }
    await resetCart(req.user._id);

    // req.body.data = createPaymentData(cart);
    // paymentSheet(req, res)
    return res.status(200).json({ message: 'Order Success', order_id: order._id });
}

async function httpPayForOrder(req, res) {
    const order = await getOrderWithPopulate(req.params.id);
    if (!order) return res.status(400).json({ message: 'Order Not Found' });
    const payment_data = createPaymentData(order, order.total_price, 'order');
    req.body.data = payment_data;
    paymentSheet(req, res);
}

module.exports = {
    httpGetOrders,
    httpGetOrder,
    httpPostOrder,
    httpPayForOrder
};
