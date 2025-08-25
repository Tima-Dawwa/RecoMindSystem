const mongoose = require('mongoose');
const orderItemSchema = require('./orderItem.mongo');

const orderSchema = new mongoose.Schema({
    user_id: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    orderItems: [orderItemSchema],
    total_price: {
        type: Number,
        required: true,
        min: 0
    },
    status: {
        type: String,
        enum: ['prepare', 'delivery'],
        default: 'prepare',
        required: true
    }

}, { timestamps: true })

module.exports = mongoose.model('Order', orderSchema)