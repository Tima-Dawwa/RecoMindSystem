const { productData } = require('./favorites.serializer');
const { getPagination } = require('../../../services/query');
const { serializedData } = require('../../../services/serializeArray');
const { INTERACTION_TYPES } = require('../../../public/constants/interaction')
const { getProductById, incrementInteractionCount } = require('../../../models/products.model');
const { postInteraction, removeProductInteraction } = require('../../../models/interactions.model');
const { getFavorites, addFavorite, deleteFavorite, getFavoritesCount, checkFavorite } = require('../../../models/favorites.model');

// Done
async function httpGetFavorites(req, res) {
    const { skip, limit } = getPagination(req.query)
    const data = await getFavorites(req.user.id, skip, limit) ?? [];
    const length = await getFavoritesCount(req.user.id)
    if (data.length == 0) return res.status(200).json({ data: [], count: 0 })
    return res.status(200).json({ data: serializedData(data.products_id, productData), count: length })
}

// Done
async function httpAddFavorite(req, res) {
    const product = await getProductById(req.params.id)
    if (!product) return res.status(400).json({ error: "Product Not Found" });

    const check = await checkFavorite(req.user.id, req.params.id)
    if (check) return res.status(400).json({ error: "Product Already Favorited" });

    await addFavorite(req.user.id, product._id)
    await postInteraction(req.user.id, req.params.id, INTERACTION_TYPES.FAVORITE)
    await incrementInteractionCount(req.params.id, INTERACTION_TYPES.FAVORITE)
    return res.status(200).json({
        message: 'Product favorited successfully',
    });
}

// Done
async function httpRemoveFavorite(req, res) {
    const product = await getProductById(req.params.id);
    if (!product) return res.status(404).json({ message: "Product Not Found" });
    await deleteFavorite(req.user.id, product._id);
    await removeProductInteraction(req.params.id, req.user.id, INTERACTION_TYPES.FAVORITE);
    return res.status(200).json({
        message: "Removed From Favorites Successfully",
    });
}

module.exports = {
    httpGetFavorites,
    httpAddFavorite,
    httpRemoveFavorite
}