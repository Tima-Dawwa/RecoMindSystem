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

    return res.status(200).json({ data: productDetailsData(product) })
}

module.exports = {
    httpGetAllProducts,
    httpGetOneProduct
}