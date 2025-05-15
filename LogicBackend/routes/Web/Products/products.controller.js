const axios = require('axios');
const { getProducts, getProductById, getProductsCount } = require('../../../models/products.model');
const { getPagination } = require('../../../services/query');
const { serializedData } = require('../../../services/serializeArray');
const { productData, productDetailsData } = require('./products.serializer');

async function httpGetAllProducts(req, res) {
    const { skip, limit } = getPagination(req.query)
    const data = await getProducts(skip, limit)
    const length = getProductsCount()

    return res.status(200).json({ data: serializedData(data, productData), count: length })
}

async function httpGetOneProduct(req, res) {
    const product = await getProductById(req.params.id)
    if (!product) return res.status(404).json({ message: "Product Not Found" })

    // Need to add interaction
    const recommendations = await axios.get('http://127.0.0.1:8000/recommendations', {
        params: { product_id: req.params.id, top_n: 5 }
    });

    return res.status(200).json({ data: productDetailsData(product), recommendations })
}

module.exports = {
    httpGetAllProducts,
    httpGetOneProduct
}