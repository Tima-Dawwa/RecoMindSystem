const ChatbotInteraction = require("./chatbot_interaction.mongo");

async function postChatbotInteraction(data) {
    return await ChatbotInteraction.create(data);
}

async function getChatbotInteractions() {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const startDate = new Date(today);
    startDate.setDate(today.getDate() - 7);

    const endDate = new Date(today);
    endDate.setDate(today.getDate() - 1);

    return await ChatbotInteraction.aggregate([
        {
            $match: {
                createdAt: { $gte: startDate, $lte: endDate }
            }
        },
        {
            $group: {
                _id: {
                    day: { $dateToString: { format: "%Y-%m-%d", date: "$createdAt" } },
                    type: "$input_type"
                },
                avgSimilarity: { $avg: "$similarity_metric.avg" },
                avgTop1: { $avg: "$similarity_metric.top1" },
                avgTop3: { $avg: "$similarity_metric.top3_avg" }
            }
        },
        { $sort: { "_id.day": 1 } }
    ]);
}

module.exports = {
    getChatbotInteractions,
    postChatbotInteraction
};
