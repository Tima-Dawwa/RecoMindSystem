const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema({
    user_id: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    products_id: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Product',
        required: true
    }],
    total_price: {
        type: Number,
        required: true,
        min: 0
    }
}, { timestamps: true })

module.exports = mongoose.model('Order', orderSchema);