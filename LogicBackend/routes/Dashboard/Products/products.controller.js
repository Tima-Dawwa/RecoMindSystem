const { getProducts, getProductById, postProduct, deleteProduct } = require('../../../models/products.model');
const { getPagination } = require('../../../services/query');
const { serializedData } = require('../../../services/serializeArray');
const { productData } = require('./products.serializer');
const { validationErrors } = require('../../../middlewares/validationErrors');


async function httpGetAllProducts(req, res) {
    const { skip, limit } = getPagination(req.query)
    const data = await getProducts(skip, limit)


    return res.status(200).json({ data: serializedData(data, productData), count: length })
}

async function httpGetOneProduct(req, res) {
    const data = await getProductById(req.params.id)


    return res.status(200).json({ data: productData(data) })
}

async function httpPostProduct(req, res) {
    const { error } = validateCreateProduct(req.body);
    if (error) return res.status(404).json({ errors: validationErrors(error.details) })

    await postProduct(req.body)
    return res.status(200).json({ message: "Product Succefully Added" })

}

async function httpDeleteProduct(req, res) {
    const product = await getProductById(req.params.id)
    if (!product) return res.status(404).json({ message: "Product Not Found" })

    await deleteProduct(req.params.id)
    return res.status(200).json({ message: "Product Succefully Deleted" })
}


module.exports = {
    httpGetAllProducts,
    httpGetOneProduct,
    httpPostProduct,
    httpDeleteProduct
}