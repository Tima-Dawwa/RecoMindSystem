const { getProducts, getProductById, postProduct, deleteProducts, getProductsCount, getManyProducts, updateProduct } = require('../../../models/products.model');
const { getPagination } = require('../../../services/query');
const { serializedData } = require('../../../services/serializeArray');
const { productData, productDetailsData } = require('./products.serializer');
const { validateCreateProduct, validateEditProduct } = require('./products.validation');
const { validationErrors } = require('../../../middlewares/validationErrors');
const { getProductRatings } = require('../../../models/interactions.model');

// done
async function httpGetAllProducts(req, res) {
    const { skip, limit } = getPagination(req.query);
    const { name, gender } = req.query;
    const filters = {
        name: name,
        gender: gender
    };
    const data = await getProducts(filters, skip, limit);
    const length = await getProductsCount(filters);
    return res.status(200).json({ data: serializedData(data, productData), count: length });
}

// done
async function httpGetOneProduct(req, res) {
    const product = await getProductById(req.params.id);
    if (!product) {
        return res.status(404).json({ error: 'Product not found' });
    }
    const ratings = await getProductRatings(req.params.id);
    return res.status(200).json({
        data: productDetailsData(product, ratings)
    });
}

// done
async function httpPostProduct(req, res) {
    const { error } = validateCreateProduct(req.body);
    if (error) return res.status(404).json({ errors: validationErrors(error.details) });
    const imageFilenames = req.files?.map(file => '/images/products/' + file.filename) || [];

    if (imageFilenames.length === 0) {
        return res.status(400).json({ errors: [{ message: 'At least one image is required.' }] });
    }

    const productData = {
        ...req.body,
        images: imageFilenames
    };

    const product = await postProduct(productData);

    try {
        await axios.post(`http://127.0.0.1:8000/content-recommendations?product_id=${product._id}`);
    } catch (error) {
        console.error('Adding Product to faiss index failed:', error.message);
    }

    return res.status(200).json({ message: 'Product Successfully Added' });
}

// done
async function httpDeleteProduct(req, res) {
    const { ids } = req.body;

    if (!Array.isArray(ids) || ids.length === 0) {
        return res.status(400).json({ message: 'Array of product IDs is required.' });
    }

    const foundProducts = await getManyProducts(ids);

    if (foundProducts.length !== ids.length) {
        return res.status(404).json({ message: 'One or more products not found.' });
    }

    await deleteProducts(ids);
    return res.status(200).json({ message: 'Product Succefully Deleted' });
}

async function httpPutProduct(req, res) {
    const { error } = validateEditProduct(req.body);
    if (error) return res.status(404).json({ errors: validationErrors(error.details) });

    const product = await getProductById(req.params.id);
    if (!product) {
        return res.status(404).json({ error: 'Product not found' });
    }

    const newImages = req.files?.map(file => '/images/products/' + file.filename) || [];

    let imagesToKeep = req.body.imagesToKeep;

    const finalImages = [...imagesToKeep, ...newImages];

    const updatedData = {
        ...req.body,
        images: finalImages
    };

    await updateProduct(req.params.id, updatedData);
    return res.status(200).json({ message: 'Product Successfully Edited' });
}

module.exports = {
    httpGetAllProducts,
    httpGetOneProduct,
    httpPostProduct,
    httpDeleteProduct,
    httpPutProduct
};
