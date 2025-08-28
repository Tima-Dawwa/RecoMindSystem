const { getChatbotSimilarityStats, getChatbotResponseTimeStats } = require('../../../models/chatbot_interaction.model');
const { getRecommendationSimilarityStats, getRecommendationResponseTimeStats } = require('../../../models/recommendation_interaction.model');

async function getChatbotSimilarityStatsController(req, res) {
    const data = await getChatbotSimilarityStats();
}

async function getChatbotResponseTimeStatsController(req, res) {
    const data = await getChatbotResponseTimeStats();
}

async function getRecommendationSimilarityStatsController(req, res) {
    const data = await getRecommendationSimilarityStats();
}

async function getRecommendationResponseTimeStatsController(req, res) {
    const data = await getRecommendationResponseTimeStats();
}

module.exports = {
    getChatbotSimilarityStatsController,
    getChatbotResponseTimeStatsController,
    getRecommendationSimilarityStatsController,
    getRecommendationResponseTimeStatsController
};
