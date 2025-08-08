function chatData(chat) {
    return {
        id: chat._id,
        chat_name: chat.name,
    }
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
        isFavorite: product.isFavorite,
        image: product.images[0],
    };
}

module.exports = {
    chatData,
    productData
}