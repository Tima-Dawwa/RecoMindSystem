const { getOrders, getOrder } = require('../../../models/orders.model');
const { getPagination } = require('../../../services/query');
const { serializedData } = require('../../../services/serializeArray');
const { orderData } = require('./orders.serializer');

async function httpGetOrders(req, res) {
    const { skip, limit } = getPagination(req.query)
    const data = await getOrders(req.user.id, skip, limit)
    return res.status(200).json({ data: serializedData(data, orderData), count: length })
}

async function httpGetOrder(req, res) {
    const data = await getOrder(req.params.id)
    if (!data) return res.status(404).json({ message: "Order Not Found" })
    return res.status(200).json({ data: orderData(data) })
}

module.exports = {
    httpGetOrders,
    httpGetOrder
}