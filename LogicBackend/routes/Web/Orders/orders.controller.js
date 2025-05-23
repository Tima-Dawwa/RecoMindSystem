const { getCart } = require('../../../models/cart.model');
const { getOrdersForUser, getOrder, getOrdersCountForUser } = require('../../../models/orders.model');
const { getPagination } = require('../../../services/query');
const { serializedData } = require('../../../services/serializeArray');
const { orderData } = require('./orders.serializer');
const { paymentSheet } = require('../Payments/payments.controller')

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
    httpGetOrders,
    httpGetOrder,
    httpPostOrder
}