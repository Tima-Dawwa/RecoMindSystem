const Cart = require('./cart.mongo');

async function getCart(user_id, skip, limit) {
    return await Cart.find({ user_id }).skip(skip).limit(limit);
}

async function deleteFromCart(user_id, product_id) {
    return await Cart.findOneAndUpdate(
        { user_id: user_id },
        { $pull: { products_id: product_id } },
        { new: true }
    );
}

async function addToCart(user_id, product_id) {
    await Cart.findOneAndUpdate(
        { user_id: user_id },
        { $addToSet: { products_id: product_id } },
        { upsert: true, new: true, setDefaultsOnInsert: true }
    );
}

module.exports = {
    getCart,
    addToCart,
    deleteFromCart,
}
