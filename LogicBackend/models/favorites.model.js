const Favorite = require('./favorites.mongo');

async function getFavorites(user_id, skip, limit) {
    return await Favorite.find({ user_id }).skip(skip).limit(limit);
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

module.exports = {
    getFavorites,
    addFavorite,
    deleteFavorite,
}
