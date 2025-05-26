const mongoose = require('mongoose');
const cartItemSchema = require('./cartItem.mongo')

const cartSchema = new mongoose.Schema({
    user_id: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
        unique: true
    },
    items: [cartItemSchema],
    total_price: {
        type: Number,
        default: 0,
        min: 0
    }
}, { timestamps: true });

// Calculate total price before saving
cartSchema.pre('save', function (next) {
    this.total_price = this.items.reduce((total, item) => {
        return total + (item.price * item.quantity);
    }, 0);
    next();
});

// Update total price when items are modified
cartSchema.post('findOneAndUpdate', async function (doc) {
    if (doc) { // Make sure doc exists
        doc.total_price = doc.items.reduce((total, item) => {
            return total + (item.price * item.quantity);
        }, 0);
        await doc.save();
    }
});

module.exports = mongoose.model('Cart', cartSchema);