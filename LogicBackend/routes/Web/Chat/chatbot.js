const axios = require('axios');

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
        recommendedProducts: []
    };
}

module.exports = {
    getChatbotResponse
}