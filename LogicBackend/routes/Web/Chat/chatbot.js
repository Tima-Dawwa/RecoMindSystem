const axios = require('axios');
const { getProductById } = require('../../../models/products.model');
const { productData } = require('./chat.serializer');

async function getChatbotResponse({ message, image }) {
    const response = await axios.post('http://127.0.0.1:8000/chatbot', {
        message: message,
        image: image
    });
    let answer = response.data.answer;
    let recommendedProducts = response.data.recommendations;
    let similarities = response.data.similarities;
    console.log(similarities);
    return {
        message: answer, // string
        recommendedProducts: recommendedProducts, // array of ids
        similarities: similarities // array of numbers
    };
}

module.exports = {
    getChatbotResponse
};
