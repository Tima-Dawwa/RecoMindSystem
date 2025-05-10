function productData(product) {
    return {
        product: {
            name: product.name,
            price: product.price,
            discounted_price: product.discounted_price,
            gender: product.gender,
            details: product.description,
        }
    }
}

function productDetailsData(product) {
    return {
        product: {

        }
    }
}

module.exports = {
    productData,
    productDetailsData
}