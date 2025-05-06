const { getProducts, getProductById } = require('../../../models/products.model');
const { getPagination } = require('../../../services/query');
const { serializedData } = require('../../../services/serializeArray');
const { productData } = require('./products.serializer');

async function httpGetAllProducts(req, res) {
    const { skip, limit } = getPagination(req.query)
    const data = await getProducts(skip, limit)


    return res.status(200).json({ data: serializedData(data, productData), count: length })
}

async function httpGetOneProduct(req, res) {
    const product = await getProductById(req.params.id)
    if (!product) return res.status(404).json({ message: "Product Not Found" })

    return res.status(200).json({ data: productData(product) })
}


module.exports = {
    httpGetAllProducts,
    httpGetOneProduct
}