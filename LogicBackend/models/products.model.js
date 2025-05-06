const Product = require('./products.mongo');

async function postProduct(data) {
    return await Product.create(data);
}

async function getProducts(skip, limit) {
    return await Product.find().skip(skip).limit(limit);
}

async function getProductById(_id) {
    return await Product.find({ _id })
}

async function deleteProduct(product_id) {
    return await Product.deleteOne({ _id: product_id });
}



module.exports = {
    postProduct,
    getProducts,
    getProductById,
    deleteProduct
}