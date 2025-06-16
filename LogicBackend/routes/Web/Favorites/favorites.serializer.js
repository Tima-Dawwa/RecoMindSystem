function productData(product) {
    return {
        id: product._id,
        name: product.name,
        price: product.price,
        discounted_price: product.discounted_price,
        is_discounted: (product.price - product.discounted_price) > 0,
        department: product.department,
        isNew: product.isNew,
        isTrend: product.isTrend
    }
}

module.exports = {
    productData
}