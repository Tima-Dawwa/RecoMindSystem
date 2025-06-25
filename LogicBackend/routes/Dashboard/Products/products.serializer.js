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
        isFinished: product.quantity == 0,
        image: product.images[0],
        quantity: product.quantity,
    };
}

function productDataRecommendations(product) {
    return {
        id: product._id,
        parent_id: product.parent_id,
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

function productDetailsData(product, ratings) {
    return {
        id: product._id,
        name: product.name,
        price: product.price,
        discounted_price: product.discounted_price,
        details: product.details,
        graphic: product.appearance,
        gender: product.gender,
        department: product.department,
        color: product.color,
        images: product.images,
        quantity: product.quantity,
        ratings: ratings,

        num_favorites: product.interactions.favorite || 0,
        num_views: product.interactions.view || 0,
        num_sales: product.interactions.order || 0,
    };
}


module.exports = {
    productData,
    productDetailsData,
    productDataRecommendations
};
