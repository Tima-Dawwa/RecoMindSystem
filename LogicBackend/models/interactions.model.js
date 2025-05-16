const Product = require('./products.mongo');
const Interaction = require('./interactions.mongo');

async function getInteractions(skip, limit) {
    return await Interaction.find().skip(skip).limit(limit);
}

async function getInteraction(interaction_id) {
    return await Interaction.findById(interaction_id);
}

async function postInteraction(data) {
    await Interaction.create(data)
}

async function deleteInteraction(interaction_id) {
    await Interaction.findByIdAndDelete(interaction_id)
}

async function updateProductInteraction(productId, userId, interactionType) {
    
    await Interaction.create({
        user_id: userId,
        product_id: productId,
        interaction_type: interactionType
    });

    
    const updateField = `interactions.${interactionType}s`;
    const update = {
        $inc: {
            [updateField]: 1,
            'interactions.total_interactions': 1
        }
    };

    return await Product.findByIdAndUpdate(
        productId,
        update,
        { new: true }
    );
}

async function getProductInteractions(productId) {
    return await Interaction.find({ product_id: productId })
        .populate('user_id', 'name email')
        .sort({ createdAt: -1 });
}

async function getUserInteractions(userId) {
    return await Interaction.find({ user_id: userId })
        .populate('product_id', 'name price')
        .sort({ createdAt: -1 });
}

module.exports = {
    getInteractions,
    getInteraction,
    postInteraction,
    deleteInteraction,
    updateProductInteraction,
    getProductInteractions,
    getUserInteractions
}
