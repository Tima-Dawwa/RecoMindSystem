function cartData(product) {
    return {
        id: product.product._id,
        name: product.product.name,
        price: product.price,
        department: product.product.department,
        image: product.product.images[0],
        color: product.product.color,
        quantity: product.quantity,
    }
}

module.exports = {
    cartData
}
