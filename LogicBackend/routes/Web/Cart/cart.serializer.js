function cartData(product) {
    return {
        id: product.product._id,
        name: product.product.name,
        price: product.product.price,
        discounted_price: product.product.discounted_price,
        is_discounted: (product.product.price - product.product.discounted_price) > 0,
        department: product.product.department,
    }
}

module.exports = {
    cartData
}