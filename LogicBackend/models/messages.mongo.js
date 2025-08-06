const mongoose = require('mongoose');

const messageSchema = new mongoose.Schema({
    senderType: {
        type: String,
        enum: ['user', 'system'],
        required: true
    },
    content: {
        type: String,
        required: true
    },
    image: {
        type: String,
        required: false,
        default: null
    },
    timestamp: {
        type: Date,
        default: Date.now
    },
    recommendedProducts: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Product'
    }]
}, { _id: false });

module.exports = messageSchema