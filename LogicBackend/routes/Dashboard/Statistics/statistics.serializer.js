function similarityData(data) {
    const grouped = {};

    data.forEach(item => {
        const type = item._id.type;
        if (!grouped[type]) grouped[type] = [];
        grouped[type].push({
            day: item._id.day,
            avgSimilarity: item.avgSimilarity,
            avgTop1: item.avgTop1,
            avgTop3: item.avgTop3
        });
    });

    return Object.keys(grouped).map(type => ({
        type,
        days: grouped[type]
    }));
}

function responseTimeData(data) {
    return data.map(item => ({
        type: item._id,
        avgResponseTime: item.avgResponseTime
    }));
}


module.exports = {
    similarityData,
    responseTimeData
}