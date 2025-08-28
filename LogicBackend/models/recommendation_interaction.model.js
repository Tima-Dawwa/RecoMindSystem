const RecommendationInteraction = require("./recommendation_interaction.mongo");

async function postRecommendationInteraction(data) {
    return await RecommendationInteraction.create(data);
}

async function getRecommendationSimilarityStats() {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const startDate = new Date(today);
    startDate.setDate(today.getDate() - 7);

    const endDate = new Date(today);
    endDate.setDate(today.getDate() - 1);

    return await RecommendationInteraction.aggregate([
        {
            $match: {
                createdAt: { $gte: startDate, $lte: endDate }
            }
        },
        {
            $group: {
                _id: {
                    day: { $dateToString: { format: "%Y-%m-%d", date: "$createdAt" } },
                    type: "$rec_type"
                },
                avgSimilarity: { $avg: "$similarity_metric.avg" },
                avgTop1: { $avg: "$similarity_metric.top1" },
                avgTop3: { $avg: "$similarity_metric.top3_avg" }
            }
        },
        { $sort: { "_id.day": 1 } }
    ]);
}

async function getRecommendationResponseTimeStats() {
    return await RecommendationInteraction.aggregate([
        {
            $group: {
                _id: "$rec_type",
                avgResponseTime: { $avg: "$response_time" }
            }
        }
    ]);
}

module.exports = {
    postRecommendationInteraction,
    getRecommendationSimilarityStats,
    getRecommendationResponseTimeStats
};
