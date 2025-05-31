const { getFavorites, addFavorite, deleteFavorite, getFavoritesCount } = require('../../../models/favorites.model');
const { getPagination } = require('../../../services/query');
const { serializedData } = require('../../../services/serializeArray');
const { productData } = require('./favorites.serializer');
const { updateProductInteraction, getProductInteractionCount } = require('../models/interactions.model');
const { INTERACTION_TYPES } = require('../constants');

async function httpGetFavorites(req, res) {
    const { skip, limit } = getPagination(req.query)
    const data = await getFavorites(req.user.id, skip, limit)
    const length = getFavoritesCount(user_id)
    return res.status(200).json({ data: serializedData(data, productData), count: length })
}

async function httpAddFavorite(req, res) {
    try {
        const result = await updateProductInteraction(req.params.id, req.user._id, INTERACTION_TYPES.FAVORITE);
        const count = await getProductInteractionCount(req.params.id, INTERACTION_TYPES.FAVORITE);
        return res.status(200).json({
            message: 'Product favorited successfully',
            count: count
        });
    } catch (error) {
        return res.status(400).json({ error: error.message });
    }
}

async function httpRemoveFavorite(req, res) {
    const product = await getProductById(req.params.id)
    if (!product) return res.status(404).json({ message: "Product Not Found" })

    await deleteFavorite(req.user.id, product.id)
    // Need to remove interaction

    return res.status(200).json({ message: "Removed From Favorites Successfully" })

}

module.exports = {
    httpGetFavorites,
    httpAddFavorite,
    httpRemoveFavorite
}