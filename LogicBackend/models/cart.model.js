const Cart = require('./cart.mongo');

async function getCart(user_id, skip = 0, limit = 10) {
    const cart = await Cart.findOne({ user_id }).populate('items.product');
    if (!cart) return null;
    cart.items = cart.items.slice(skip, skip + limit);
    return cart;
}

async function getCartItem(user_id, product_id) {
    const cart = await Cart.findOne({ user_id: user_id, "items.product": product_id });
    return cart;
}

async function addToCart(user_id, product_id, price, quantity = 1) {
    return await Cart.findOneAndUpdate(
        { user_id },
        {
            $push: {
                items: {
                    product: product_id,
                    quantity,
                    price
                }
            },
            $inc: {
                total_price: quantity * price
            }
        },
        { upsert: true, new: true, setDefaultsOnInsert: true }
    );
}

async function updateCartItem(user_id, product_id, newQuantity) {
    return await Cart.findOneAndUpdate(
        { user_id, "items.product": product_id },
        { $set: { "items.$.quantity": newQuantity } },
        { new: true }
    );
}

async function deleteFromCart(user_id, product_id) {
    return await Cart.findOneAndUpdate(
        { user_id },
        { $pull: { items: { product: product_id } } },
        { new: true }
    );
}

async function resetCart(user_id) {
    return await Cart.findOneAndUpdate(
        { user_id },
        { $set: { items: [], total_price: 0 } },
        { new: true }
    );
}

async function getCartCount(user_id) {
    const cart = await Cart.findOne({ user_id });
    return cart ? cart.items.reduce((total, item) => total + item.quantity, 0) : 0;
}

async function getCartTotal(user_id) {
    const cart = await Cart.findOne({ user_id });
    return cart ? cart.total_price : 0;
}

module.exports = {
    getCart,
    addToCart,
    updateCartItem,
    deleteFromCart,
    resetCart,
    getCartCount,
    getCartTotal,
    getCartItem
};