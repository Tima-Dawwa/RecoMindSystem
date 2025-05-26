const { getCart } = require('../../../models/cart.model');
const { getOrdersForUser, getOrder, getOrdersCountForUser } = require('../../../models/orders.model');
const { getPagination } = require('../../../services/query');
const { serializedData } = require('../../../services/serializeArray');
const { orderData } = require('./orders.serializer');
const { paymentSheet } = require('../Payments/payments.controller')
const { updateProductInteraction, getProductInteractionCount } = require('../models/interactions.model');
const { INTERACTION_TYPES } = require('../constants');

async function httpAddOrder(req, res) {
    try {
        const result = await updateProductInteraction(req.params.id, req.user._id, INTERACTION_TYPES.ORDER);
        const count = await getProductInteractionCount(req.params.id, INTERACTION_TYPES.ORDER);
        return res.status(200).json({ 
            message: 'Order recorded successfully',
            count: count
        });
    } catch (error) {
        return res.status(400).json({ error: error.message });
    }
}
async function httpGetOrders(req, res) {
    const { skip, limit } = getPagination(req.query)
    const data = await getOrdersForUser(req.user.id, skip, limit)
    const length = getOrdersCountForUser()
    return res.status(200).json({ data: serializedData(data, orderData), count: length })
}

async function httpGetOrder(req, res) {
    const data = await getOrder(req.params.id)
    if (!data) return res.status(404).json({ message: "Order Not Found" })
    return res.status(200).json({ data: orderData(data) })
}

async function httpPostOrder(req, res) {
    const data = await getCart(req.user._id)
    if (!data) return res.status(404).json({ message: "No Cart Found" })

    const cart = await getCart(req.user._id);
    req.body.data = createPaymentData(cart);
    paymentSheet(req, res)
}

module.exports = {
    httpAddOrder,
    httpGetOrders,
    httpGetOrder,
    httpPostOrder
}