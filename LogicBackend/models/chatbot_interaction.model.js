const ChatbotInteraction = require('./chatbot_interaction.mongo');

async function postChatbotInteraction(data) {
    return await ChatbotInteraction.create(data);
}

async function getChatbotSimilarityStats() {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const endDate = new Date(today);
    endDate.setDate(today.getDate() - 1);
    endDate.setHours(23, 59, 59, 999);

    const startDate = new Date(endDate);
    startDate.setDate(endDate.getDate() - 6);
    startDate.setHours(0, 0, 0, 0);

    return await ChatbotInteraction.aggregate([
        {
            $match: {
                createdAt: { $gte: startDate, $lte: endDate }
            }
        },
        {
            $group: {
                _id: {
                    day: { $dateToString: { format: '%Y-%m-%d', date: '$createdAt' } },
                    type: '$input_type'
                },
                avgSimilarity: { $avg: '$similarity_metric.avg' },
                avgTop1: { $avg: '$similarity_metric.top1' },
                avgTop3: { $avg: '$similarity_metric.top3_avg' }
            }
        },
        { $sort: { '_id.day': 1 } }
    ]);
}

async function getChatbotResponseTimeStats() {
    return await ChatbotInteraction.aggregate([
        {
            $group: {
                _id: '$input_type',
                avgResponseTime: { $avg: '$response_time' }
            }
        }
    ]);
}

async function getChatbotTypesUsage() {
    const pipeline = [
        {
            $group: {
                _id: '$input_type',
                count: { $sum: 1 }
            }
        }
    ];

    const results = await ChatbotInteraction.aggregate(pipeline);

    const usage = {};
    results.forEach(item => {
        usage[item._id] = item.count;
    });

    const allTypes = ['text', 'image', 'text+image'];
    allTypes.forEach(type => {
        if (!usage[type]) usage[type] = 0;
    });

    return usage;
}

module.exports = {
    getChatbotSimilarityStats,
    postChatbotInteraction,
    getChatbotResponseTimeStats,
    getChatbotTypesUsage
};
