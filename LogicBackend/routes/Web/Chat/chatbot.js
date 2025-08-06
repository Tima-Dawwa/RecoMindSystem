const axios = require('axios');
const { getProductById } = require('../../../models/products.model');
const { productData } = require('./chat.serializer');

async function getChatbotResponse({ message, image, userId }) {
    const response = await axios.post(
        "http://127.0.0.1:8000/chatbot",
        {
            message: message,
            image: image,
            userId: userId
        }
    );
    return {
        message: response.data,
        recommendedProducts: [
            "686bf63efaa50d1ee8f52a1d"
        ]
    };
}

module.exports = {
    getChatbotResponse
}