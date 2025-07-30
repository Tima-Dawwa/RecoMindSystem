const mongoose = require('mongoose');
const messageSchema = require('./messages.mongo');

const chatSchema = new mongoose.Schema({
    user_id: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    name: {
        type: String,
        required: true
    },
    messages: [messageSchema],
}, { timestamps: true })


module.exports = mongoose.model('Chat', chatSchema)