const { getFavorites, addFavorite, deleteFavorite } = require('../../../models/favorites.model');
const { getPagination } = require('../../../services/query');
const { serializedData } = require('../../../services/serializeArray');
const { productData } = require('./favorites.serializer');

async function httpGetFavorites(req, res) {
    const { skip, limit } = getPagination(req.query)
    const data = await getFavorites(req.user.id, skip, limit)
    return res.status(200).json({ data: serializedData(data, productData), count: length })
}

async function httpAddFavorite(req, res) {
    const product = await getProductById(req.params.id)
    if (!product) return res.status(404).json({ message: "Product Not Found" })

    await addFavorite(req.user.id, product.id)
    // Need to add interaction


    return res.status(200).json({ message: "Added To Favorites Successfully" })
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