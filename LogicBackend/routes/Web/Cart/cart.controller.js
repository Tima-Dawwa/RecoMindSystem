const axios = require('axios');
const { cartData, productData } = require('./cart.serializer');
const { getPagination } = require('../../../services/query');
const { serializedData } = require('../../../services/serializeArray');
const { INTERACTION_TYPES } = require('../../../public/constants/interaction');
const { getProductById, incrementInteractionCount, getProductsByIds, getRandomProduct } = require('../../../models/products.model');
const { postInteraction, removeProductInteraction } = require('../../../models/interactions.model');
const { postRecommendationInteraction } = require('../../../models/recommendation_interaction.model');
const { getCart, addToCart, deleteFromCart, getCartCount, getCartItem } = require('../../../models/cart.model');
const { checkFavorite } = require('../../../models/favorites.model');

// Done
async function httpGetCart(req, res) {
    const { skip, limit } = getPagination(req.query);
    const data = (await getCart(req.user.id, skip, limit)) ?? [];
    const length = await getCartCount(req.user.id);
    if (data.length == 0) return res.status(200).json({ data: [], count: 0 });

    let productId = data.items[0]?.product._id || '';

    if (!productId) {
        productId = await getRandomProduct();
    }
    const startTime = Date.now();

    let recommendationsData = [];
    let recommendedProducts = [];
    try {
        const recommendations = await axios.get('http://127.0.0.1:8000/hybrid-recommendations', {
            params: {
                user_id: req.user?.id || '',
                product_id: productId,
                top_n: 5
            }
        });

        recommendationsData = recommendations.data;
        let recommendedIds = recommendationsData.map(r => r.id);
        recommendedProducts = await getProductsByIds(recommendedIds);

        recommendedProducts = await Promise.all(
            recommendedProducts.map(async p => {
                p.isFavorite = (await checkFavorite(req.user.id, p._id)) ? true : false;
                return p;
            })
        );

        const similarities = recommendationsData.map(r => r.similarity || 1);
        const response_time = (Date.now() - startTime) / 1000;
        await postRecommendationInteraction({
            rec_type: 'hybrid',
            similarities,
            response_time
        });
    } catch (error) {
        console.error('Hybrid recommendation error:');
    }

    return res.status(200).json({
        data: serializedData(data.items, cartData),
        recommendations: serializedData(recommendedProducts, productData),
        count: length
    });
}

// Done
async function httpAddToCart(req, res) {
    const product = await getProductById(req.params.id);
    if (!product) return res.status(400).json({ error: 'Product Not Found' });
    const product_found = await getCartItem(req.user._id, product._id);
    if (product_found) return res.status(200).json({ error: 'Product Already in Cart' });

    // decrease quantity
    // if (product.quantity < req.body.quantity) return res.status(400).json({ error: 'Not Enough Items in Storage' })
    await addToCart(req.user._id, req.params.id, product.discounted_price, req.body.quantity);
    await postInteraction(req.user.id, req.params.id, INTERACTION_TYPES.CART_ADD);
    await incrementInteractionCount(req.params.id, INTERACTION_TYPES.CART_ADD);

    return res.status(200).json({ message: 'Product Added To Cart' });
}

// Done
async function httpRemoveFromCart(req, res) {
    const product = await getProductById(req.params.id);
    if (!product) return res.status(404).json({ message: 'Product Not Found' });

    const product_found = await getCartItem(req.user._id, product._id);
    if (!product_found) return res.status(200).json({ error: 'Product not in Cart' });

    await deleteFromCart(req.user._id, product._id);
    await removeProductInteraction(req.params.id, req.user._id, INTERACTION_TYPES.CART_ADD);

    return res.status(200).json({
        message: 'Removed From Cart Successfully'
    });
}

module.exports = {
    httpGetCart,
    httpAddToCart,
    httpRemoveFromCart
};
