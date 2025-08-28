function cartData(product) {
    return {
        id: product.product._id,
        name: product.product.name,
        max_quantity: product.product.quantity,
        price: product.price,
        department: product.product.department,
        image: product.product.images[0],
        color: product.product.color,
        quantity: product.quantity
    };
}

module.exports = {
    cartData
};
