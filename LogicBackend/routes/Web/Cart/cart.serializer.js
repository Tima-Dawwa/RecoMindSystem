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

function productData(product) {
    return {
        id: product._id,
        name: product.name,
        price: product.price,
        discounted_price: product.discounted_price,
        is_discounted: product.price - product.discounted_price > 0,
        department: product.department,
        gender: product.gender,
        rating: product.rating,
        isNew: product.isNew,
        isTrend: product.isTrend,
        isFavorite: product.isFavorite ?? false,
        image: product.images[0]
    };
}

module.exports = {
    cartData,
    productData
};
