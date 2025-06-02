const { cartData } = require('./cart.serializer');
const { getPagination } = require('../../../services/query');
const { serializedData } = require('../../../services/serializeArray');
const { INTERACTION_TYPES } = require('../../../public/constants/interaction')
const { getProductById, incrementInteractionCount } = require('../../../models/products.model');
const { postInteraction, removeProductInteraction } = require('../../../models/interactions.model');
const { getCart, addToCart, deleteFromCart, getCartCount, getCartItem } = require('../../../models/cart.model');

// Done
async function httpGetCart(req, res) {
    const { skip, limit } = getPagination(req.query)
    const data = await getCart(req.user.id, skip, limit) ?? []
    const length = getCartCount(req.user.id)
    if (data.length == 0) return res.status(200).json({ data: [], count: 0 })
    return res.status(200).json({ data: serializedData(data.items, cartData), count: length })
}

// Done
async function httpAddToCart(req, res) {
    const product = await getProductById(req.params.id)
    if (!product) return res.status(400).json({ error: 'Product Not Found' })
    const product_found = await getCartItem(req.user._id, product._id)
    if (product_found) return res.status(200).json({ error: 'Product Already in Cart' })

    await addToCart(req.user._id, req.params.id, product.discounted_price, req.body.quantity)
    await postInteraction(req.user.id, req.params.id, INTERACTION_TYPES.CART_ADD)
    await incrementInteractionCount(req.params.id, INTERACTION_TYPES.CART_ADD)

    return res.status(200).json({ error: 'Product Added To Cart' })
}

// Done
async function httpRemoveFromCart(req, res) {
    const product = await getProductById(req.params.id);
    if (!product) return res.status(404).json({ message: "Product Not Found" });

    const product_found = await getCartItem(req.user._id, product._id)
    if (!product_found) return res.status(200).json({ error: 'Product not in Cart' })

    await deleteFromCart(req.user._id, product.id);
    await removeProductInteraction(req.params.id, req.user._id, INTERACTION_TYPES.CART_ADD);

    return res.status(200).json({
        message: "Removed From Cart Successfully",
    });
}

module.exports = {
    httpGetCart,
    httpAddToCart,
    httpRemoveFromCart
}