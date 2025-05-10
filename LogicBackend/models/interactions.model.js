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

module.exports = {
    getInteractions,
    getInteraction,
    postInteraction,
    deleteInteraction
}
