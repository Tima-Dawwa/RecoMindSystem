const axios = require('axios');
const { getProducts, getProductById, getProductsCount, getProductsByIds } = require('../../../models/products.model');
const { validationErrors } = require('../../../middlewares/validationErrors')
const { updateProductInteraction, getProductInteractions, INTERACTION_TYPES } = require('../../../models/interactions.model');
const { getPagination } = require('../../../services/query');
const { serializedData } = require('../../../services/serializeArray');
const { productData, productDetailsData } = require('./products.serializer');
const { normalizeBool, getCategory } = require('./products.helper');
const { validateProductRating } = require('./products.validation');

async function httpGetAllProducts(req, res) {
    const { skip, limit } = getPagination(req.query)
    const { type, minPrice, maxPrice, isNew, isTrend } = req.query
    const filters = {
        type: type !== undefined ? getCategory(type) : [],
        minPrice: minPrice !== undefined ? Number(minPrice) : 0,
        maxPrice: maxPrice !== undefined ? Number(maxPrice) : 999999,
        isNew: normalizeBool(isNew) ?? false,
        isTrend: normalizeBool(isTrend) ?? false
    };
    const data = await getProducts(filters, skip, limit)
    const length = await getProductsCount(filters)
    return res.status(200).json({ data: serializedData(data, productData), count: length })
}

async function httpGetOneProduct(req, res) {
    const product = await getProductById(req.params.id);
    if (!product) {
        return res.status(404).json({ error: 'Product not found' });
    }

    if (req.user)
        await updateProductInteraction(req.params.id, req.user._id, 'view');
    else {
        // need to just increment dont create interaction
    }

    let recommendedProducts = [];
    try {
        const recommendations = await axios.get('http://127.0.0.1:8000/content-recommendations', {
            params: { product_id: req.params.id, top_n: 5 }
        });
        recommendedProducts = await getProductsByIds(recommendations.data);
    } catch (error) {
    }

    return res.status(200).json({
        data: productDetailsData(product),
        recommendations: recommendedProducts
    });
}


async function httpGetProductInteractions(req, res) {
    const interactions = await getProductInteractions(req.params.id);
    return res.status(200).json({ interactions });
}

async function httpRateProduct(req, res) {
    const { error } = validateProductRating(req.body)
    if (error) {
        return res.status(400).json({
            errors: validationErrors(error.details)
        })
    }
    const result = await updateProductInteraction(
        req.params.id,
        req.user._id,
        INTERACTION_TYPES.RATING,
        req.body.rating
    );

    return res.status(200).json({
        message: 'Product rated successfully',
    });

}

module.exports = {
    httpGetAllProducts,
    httpGetOneProduct,
    httpGetProductInteractions,
    httpRateProduct
};
