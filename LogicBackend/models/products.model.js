const Product = require('./products.mongo');
const { getTrendingProductIds } = require('../models/orders.model');
const { WEIGHT_MAP, INTERACTION_TYPES } = require('../public/constants/interaction');

async function postProduct(data) {
    return await Product.create(data);
}

async function buildProductQuery(filters) {
    const query = {};
    const tenDaysAgo = new Date();
    tenDaysAgo.setDate(tenDaysAgo.getDate() - 10);

    if (filters.type.length > 0) query.type = { $in: filters.type };

    if (filters.minPrice !== undefined || filters.maxPrice !== undefined) {
        query.price = {};
        query.discounted_price = {};
        if (filters.minPrice !== undefined) {
            query.price.$gte = filters.minPrice;
            query.discounted_price.$gte = filters.minPrice;
        }
        if (filters.maxPrice !== undefined) {
            query.price.$lte = filters.maxPrice;
            query.discounted_price.$lte = filters.maxPrice;
        }
    }

    let trendingIds = [];
    if (filters.isTrend) {
        trendingIds = await getTrendingProductIds(10, 3);
        if (trendingIds.length === 0) return { query: { _id: { $in: [] } }, tenDaysAgo, trendingIds };
        query._id = { $in: trendingIds };
    }

    if (filters.isNew) {
        query.createdAt = { $gte: tenDaysAgo };
    }

    return { query, tenDaysAgo, trendingIds };
}

async function getProducts(filters, skip, limit) {
    const { query, tenDaysAgo, trendingIds } = await buildProductQuery(filters);
    const products = await Product.find(query).skip(skip).limit(limit);
    const trendingSet = new Set(trendingIds.map(id => id.toString()));
    return products.map(p => {
        const obj = p.toObject();
        return {
            ...obj,
            isNew: obj.createdAt >= tenDaysAgo,
            isTrend: trendingSet.has(obj._id.toString())
        };
    });
}

async function getProductsCount(filters) {
    const { query } = await buildProductQuery(filters);
    return await Product.countDocuments(query);
}

async function getProductById(_id) {
    return await Product.findById(_id)
}

async function deleteProduct(product_id) {
    return await Product.deleteOne({ _id: product_id });
}

async function getProductsByIds(ids) {
    return await Product.find({ _id: { $in: ids } });
}

async function incrementInteractionCount(product_id, type, rating_value = null) {
    product = await Product.findOne({ _id: product_id });
    product.interactions[type]++;
    product.interactions.total_interactions++;
    product.total_interaction_score += WEIGHT_MAP[type];
    return await product.save()
}

async function incrementRatingCount(product_id, rating_value) {
    product = await Product.findOne({ _id: product_id });
    product.rating_count++;
    product.rating = (product.rating * product.rating_count + rating_value) / product.rating_count;
    product.total_interaction_score += rating_value;
    return await product.save()
}

async function applyChangedRatingToProduct(product_id, rating_value) {
    product = await Product.findOne({ _id: product_id });
    const currentTotalRatingSum = product.rating * product.rating_count;
    product.rating = (currentTotalRatingSum - oldRatingValue + rating_value) / product.rating_count;
    product.rating = parseFloat(product.rating.toFixed(2));
    product.total_interaction_score = product.total_interaction_score - oldRatingValue + rating_value;
    return await product.save()
}

module.exports = {
    postProduct,
    getProducts,
    getProductById,
    deleteProduct,
    getProductsCount,
    getProductsByIds,
    incrementInteractionCount,
    incrementRatingCount,
    applyChangedRatingToProduct
}