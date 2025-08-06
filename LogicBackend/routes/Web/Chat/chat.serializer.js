function chatData(chat) {
    let last_message = ''
    if (chat.messages.length > 0) {
        last_message = chat.messages[chat.messages.length - 1].content
    }
    return {
        id: chat._id,
        chat_name: chat.name,
        last_message: last_message
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