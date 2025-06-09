const { getProductById } = require("../../../models/products.model")
const { serializedData } = require("../../../services/serializeArray")

function productData(product) {
    return {
        id: product._id,
        name: product.name,
        price: product.price,
        discounted_price: product.discounted_price,
        is_discounted: (product.price - product.discounted_price) > 0,
        department: product.department,
        rating: product.rating,
        isNew: product.isNew,
        isTrend: product.isTrend
    }
}

function productDetailsData(product, interactions) {
    return {
        name: product.name,
        price: product.price,
        discounted_price: product.discounted_price,
        is_discounted: (product.price - product.discounted_price) > 0,
        details: product.details,
        graphic: product.appearance,
        gender: product.gender,
        department: product.department,
        color: product.color,
        images: product.images,
        isNew: product.isNew,
        isTrend: product.isTrend,
        reviews: serializedData(interactions, interactionData)
    }
}

function interactionData(interaction) {
    const date = new Date(interaction.createdAt);
    const day = String(date.getDate()).padStart(2, '0');
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const year = date.getFullYear();

    return {
        name: `${interaction.user_id.name.first_name} ${interaction.user_id.name.last_name}`,
        rating: interaction.rating_value,
        review: interaction.review_text,
        created_at: `${day}/${month}/${year}`,
    };
}

module.exports = {
    productData,
    productDetailsData,
    interactionData
}