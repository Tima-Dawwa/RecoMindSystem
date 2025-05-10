function productData(product) {
    return {
        product: {
            name: product.name,
            price: product.price,
        }
    }
}

function productDetailsData(product) {
    return {
        product: {
            name: product.name,
            price: product.price,
            discounted_price: product.discounted_price,
            details: product.description,
            color: product.colors,
            graphic: product.appearance,
            gender: product.gender,
            department: product.department,
        }
    }
}

module.exports = {
    productData,
    productDetailsData
}