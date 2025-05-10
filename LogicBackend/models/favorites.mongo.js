const mongoose = require('mongoose');

const favoritesSchema = new mongoose.Schema({
    user_id: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    products_id: {
        type: [mongoose.Schema.Types.ObjectId],
        ref: 'Product',
        required: true
    },
}, { timestamps: true })

module.exports = mongoose.model('Favorite', favoritesSchema);