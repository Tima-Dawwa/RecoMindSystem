const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
    // Need to fill this

}, { timestamps: true })



module.exports = mongoose.model('Product', productSchema);