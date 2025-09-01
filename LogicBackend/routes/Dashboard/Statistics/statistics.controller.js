const { getChatbotSimilarityStats, getChatbotResponseTimeStats, getChatbotTypesUsage } = require('../../../models/chatbot_interaction.model');
const { getMostFavoritedProducts } = require('../../../models/favorites.model');
const { getTopCustomersByInteractions } = require('../../../models/interactions.model');
const { getLast12MonthsSales, getTopCustomersByOrders } = require('../../../models/orders.model');
const { getRecommendationSimilarityStats, getRecommendationResponseTimeStats } = require('../../../models/recommendation_interaction.model');
const { getMostUsersByCountry } = require('../../../models/users.model');
const { similarityData, responseTimeData } = require('./statistics.serializer');

async function getChatbotSimilarityStatistics(req, res) {
    const data = await getChatbotSimilarityStats();
    return res.status(200).json({ data: similarityData(data) });
}

async function getChatbotResponseTimeStatistics(req, res) {
    const data = await getChatbotResponseTimeStats();
    return res.status(200).json({ data: responseTimeData(data) });
}

async function getRecommendationSimilarityStatistics(req, res) {
    const data = await getRecommendationSimilarityStats();
    return res.status(200).json({ data: similarityData(data) });
}

async function getRecommendationResponseTimeStatistics(req, res) {
    const data = await getRecommendationResponseTimeStats();
    return res.status(200).json({ data: responseTimeData(data) });
}

async function getSalesOverTime(req, res) {
    const data = await getLast12MonthsSales();
    return res.status(200).json({ data: data });
}

async function httpGetMostFavoritedProduct(req, res) {
    const data = await getMostFavoritedProducts();
    return res.status(200).json({ data: data });
}

async function httpGetChatbotUsageType(req, res) {
    const data = await getChatbotTypesUsage();
    return res.status(200).json({ data: data });
}

async function httpGetMostUsersByCountry(req, res) {
    const data = await getMostUsersByCountry();
    return res.status(200).json({ data: data });
}

async function httpGetTopCustomersByOrders(req, res) {
    const data = await getTopCustomersByOrders();
    return res.status(200).json({ data: data });
}

async function httpGetTopCustomersByInteractions(req, res) {
    const data = await getTopCustomersByInteractions();
    return res.status(200).json({ data: data });
}

module.exports = {
    getChatbotSimilarityStatistics,
    getChatbotResponseTimeStatistics,
    getRecommendationSimilarityStatistics,
    getRecommendationResponseTimeStatistics,
    getSalesOverTime,
    httpGetMostFavoritedProduct,
    httpGetChatbotUsageType,
    httpGetMostUsersByCountry,
    httpGetTopCustomersByOrders,
    httpGetTopCustomersByInteractions
};
