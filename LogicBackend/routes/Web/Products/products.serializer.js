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

function productDetailsData(product) {
    return {
        name: product.name,
        price: product.price,
        discounted_price: product.discounted_price,
        details: product.details,
        color: product.color,
        graphic: product.appearance,
        gender: product.gender,
        department: product.department,
    }
}

module.exports = {
    productData,
    productDetailsData
}