const axios = require('axios');
const { getProducts, getProductById, getProductsCount, getProductsByIds } = require('../../../models/products.model');
const { updateProductInteraction, getProductInteractions, INTERACTION_TYPES } = require('../../../models/interactions.model');
const { getPagination } = require('../../../services/query');
const { serializedData } = require('../../../services/serializeArray');
const { productData, productDetailsData } = require('./products.serializer');

async function httpGetAllProducts(req, res) {
    const { skip, limit } = getPagination(req.query)
    const data = await getProducts(skip, limit)
    const length = getProductsCount()

    return res.status(200).json({ data: serializedData(data, productData), count: length })
}

async function httpGetProductById(req, res) {
    const product = await getProductById(req.params.id);
    
    if (!product) {
        return res.status(404).json({ error: 'Product not found' });
    }

    if (req.user) {
        await updateProductInteraction(req.params.id, req.user._id, 'view');
    }

   const recommendations = await axios.get('http://127.0.0.1:8000/recommendations', {
        params: { product_id: req.params.id, top_n: 5 }
    });
    const recommendedProducts = await getProductsByIds(recommendations.data);

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
    try {
        const { rating } = req.body;
        
        if (rating === undefined || rating === null) {
            return res.status(400).json({ error: 'Rating value is required' });
        }

        const result = await updateProductInteraction(
            req.params.id,
            req.user._id,
            INTERACTION_TYPES.RATING,
            rating
        );

        return res.status(200).json({
            message: 'Product rated successfully',
            product: result
        });
    } catch (error) {
        return res.status(400).json({ error: error.message });
    }
}

module.exports = {
    httpGetAllProducts,
    httpGetOneProduct,
    httpGetProductInteractions,
    httpRateProduct
};
