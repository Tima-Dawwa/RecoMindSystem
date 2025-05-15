const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
    // Need to fill this
    name: {
        type: String,
        required: true,
        trim: true
    },
    type: {
        type: String,
        required: true,
        trim: true
    },
    appearance: {
        type: String,
        required: true,
        trim: true
    },
    color: {
        type: String,
        required: true,
        trim: true
    },
    department: {
        type: String,
        required: true,
        trim: true
    },
    gender: {
        type: String,
        required: true,
        trim: true
    },
    details: {
        type: String,
        required: true,
        trim: true
    },
    price: {
        type: Number,
        required: true,
        min: 0
    },
    discounted_price: {
        type: Number,
        required: false,
        min: 0
    },
    quantity: {
        type: Number,
        required: true,
        min: 0
    },
    rating: {
        type: Number,
        default: 0,
    },
    rating_count: {
        type: Number,
        default: 0,
    },
    images: {
        type: [String],
        default: []
    }
}, { timestamps: true })



module.exports = mongoose.model('Product', productSchema);