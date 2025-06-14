const axios = require('axios');
const { getPagination } = require('../../../services/query');
const { validateProductRating } = require('./products.validation');
const { normalizeBool, getCategory } = require('./products.helper');
const { serializedData } = require('../../../services/serializeArray');
const { productData, productDetailsData, interactionData, productDataRecommendations } = require('./products.serializer');
const { validationErrors } = require('../../../middlewares/validationErrors')
const { getProducts, getProductById, getProductsCount, getProductsByIds, incrementInteractionCount, incrementRatingCount, applyChangedRatingToProduct } = require('../../../models/products.model');
const { getProductInteractions, postInteraction, checkRating, updateRatingInteraction } = require('../../../models/interactions.model');
const { INTERACTION_TYPES } = require('../../../public/constants/interaction')
const { checkFavorite } = require("../../../models/favorites.model");
// Done
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

// Done
async function httpGetOneProduct(req, res) {
  const product = await getProductById(req.params.id);
  if (!product) {
    return res.status(404).json({ error: "Product not found" });
  }

  if (req.user) {
    await postInteraction(req.user.id, req.params.id, INTERACTION_TYPES.VIEW);
    await incrementInteractionCount(req.params.id, INTERACTION_TYPES.VIEW);
  } else {
    await incrementInteractionCount(req.params.id, INTERACTION_TYPES.VIEW);
  }

  let recommendedProducts = [];
  try {
    const recommendations = await axios.get(
      "http://127.0.0.1:8000/content-recommendations",
      {
        params: { product_id: req.params.id, top_n: 5 },
      }
    );
    recommendedProducts = await getProductsByIds(recommendations.data);
  } catch (error) { }
  const interactions = await getProductInteractions(req.params.id);
  if (req.user) {
    product.isFavorite =
      (await checkFavorite(req.user.id, req.params.id)) ? true : false;
    recommendedProducts = await Promise.all(
      recommendedProducts.map(async (p) => {
        p.isFavorite = (await checkFavorite(req.user.id, p._id)) ? true : false;
        p.parent_id = req.params.id
        return p;
      })
    );
  } else {
    product.isFavorite = false;
    recommendedProducts.forEach((p) => (p.isFavorite = false));
  }
  return res.status(200).json({
    data: productDetailsData(product, interactions),
    recommendations: serializedData(recommendedProducts, productDataRecommendations),
  });
}

// Done
async function httpRateProduct(req, res) {
  const { error } = validateProductRating(req.body)
  if (error) {
    return res.status(400).json({
      errors: validationErrors(error.details)
    })
  }
  const product = await getProductById(req.params.id)
  if (!product) {
    return res.status(404).json({ error: "Product not found" });
  }
  await postInteraction(req.user.id, req.params.id, INTERACTION_TYPES.RATING, req.body.rating, req.body.review_text)
  await incrementRatingCount(req.params.id, req.body.rating)

  return res.status(200).json({
    message: 'Product rated successfully',
  });
}

module.exports = {
  httpGetAllProducts,
  httpGetOneProduct,
  httpRateProduct
};
