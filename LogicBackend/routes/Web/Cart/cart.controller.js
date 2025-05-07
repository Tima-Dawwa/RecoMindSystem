const { getCart, addToCart, deleteFromCart, getCartCount } = require('../../../models/cart.model');
const { getPagination } = require('../../../services/query');
const { serializedData } = require('../../../services/serializeArray');
const { cartData } = require('./cart.serializer');

async function httpGetCart(req, res) {
    const { skip, limit } = getPagination(req.query)
    const data = await getCart(req.user.id, skip, limit)
    const length = getCartCount(user_id)
    return res.status(200).json({ data: serializedData(data, cartData), count: length })
}

async function httpAddToCart(req, res) {
    const product = await getProductById(req.params.id)
    if (!product) return res.status(404).json({ message: "Product Not Found" })

    await addToCart(req.user.id, product.id)
    // Need to add interaction


    return res.status(200).json({ message: "Added To Cart Successfully" })
}

async function httpRemoveFromCart(req, res) {
    const product = await getProductById(req.params.id)
    if (!product) return res.status(404).json({ message: "Product Not Found" })

    await deleteFromCart(req.user.id, product.id)
    // Need to remove interaction

    return res.status(200).json({ message: "Removed From Cart Successfully" })

}

module.exports = {
    httpGetCart,
    httpAddToCart,
    httpRemoveFromCart
}