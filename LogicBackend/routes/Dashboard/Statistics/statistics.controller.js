const { getChatbotSimilarityStats, getChatbotResponseTimeStats } = require('../../../models/chatbot_interaction.model');
const { getRecommendationSimilarityStats, getRecommendationResponseTimeStats } = require('../../../models/recommendation_interaction.model');
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

module.exports = {
    getChatbotSimilarityStatistics,
    getChatbotResponseTimeStatistics,
    getRecommendationSimilarityStatistics,
    getRecommendationResponseTimeStatistics
};
