const { getCart, resetCart } = require('../../../models/cart.model');
const { getOrdersForUser, getOrder, getOrdersCountForUser } = require('../../../models/orders.model');
const { getPagination } = require('../../../services/query');
const { serializedData } = require('../../../services/serializeArray');
const { createPaymentData } = require('../../../services/payment');
const { orderData } = require('./orders.serializer');
const { paymentSheet } = require('../Payments/payments.controller')
const { postInteraction } = require('../../../models/interactions.model');
const { INTERACTION_TYPES } = require('../../../public/constants/interaction');
const { incrementInteractionCount } = require('../../../models/products.model');

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