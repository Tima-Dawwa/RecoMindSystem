const { mongoose } = require('mongoose');
const Favorite = require('./favorites.mongo');

async function getFavorites(user_id, skip, limit) {
    return await Favorite.findOne({ user_id })
        .populate('products_id', 'name type price discounted_price department')
        .skip(skip).limit(limit);
}

async function deleteFavorite(user_id, product_id) {
    return await Favorite.findOneAndUpdate(
        { user_id: user_id },
        { $pull: { products_id: product_id } },
        { new: true }
    );
}

async function addFavorite(user_id, product_id) {
    await Favorite.findOneAndUpdate(
        { user_id: user_id },
        { $addToSet: { products_id: product_id } },
        { upsert: true, new: true, setDefaultsOnInsert: true }
    );
}

async function getFavoritesCount(user_id) {
    const result = await Favorite.aggregate([
        { $match: { user_id } },
        { $unwind: "$products_id" },
        { $count: "totalProducts" }
    ]);
    return result.length > 0 ? result[0].totalProducts : 0;
}

async function checkFavorite(user_id, product_id) {
    return await Favorite.exists({
        user_id: user_id,
        products_id: product_id
    });
}

module.exports = {
    getFavorites,
    addFavorite,
    deleteFavorite,
    getFavoritesCount,
    checkFavorite
}
