function productData(product) {
    return {
        name: product.name,
        price: product.price,
        discounted_price: product.discounted_price,
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