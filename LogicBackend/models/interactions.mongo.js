const mongoose = require('mongoose');
const { WEIGHT_MAP } = require('../public/constants/interaction')

const interactionSchema = new mongoose.Schema({
    user_id: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    product_id: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Product',
        required: true
    },
    interaction_type: {
        type: String,
        required: true,
        enum: ['view', 'add_to_cart', 'favorite', 'order', 'rating']
    },
    interaction_weight: {
        type: Number,
        required: false,
    },
    rating_value: {
        type: Number,
        required: false,
        min: 0,
        max: 5
    }

}, { timestamps: true })

interactionSchema.pre('save', function (next) {
    if (this.interaction_type === 'rating' && this.rating_value != null) {
        this.interaction_weight = this.rating_value;
    } else if (this.isModified('interaction_type')) {
        this.interaction_weight = WEIGHT_MAP[this.interaction_type] || 0;
    }
    next();
});

module.exports = mongoose.model('Interaction', interactionSchema);