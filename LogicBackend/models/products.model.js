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

    if (filters.type && filters.type.length > 0) query.type = { $in: filters.type };

    if (filters.minPrice !== undefined || filters.maxPrice !== undefined) {
        query.$or = [
            {
                discounted_price: {
                    ...(filters.minPrice !== undefined ? { $gte: filters.minPrice } : {}),
                    ...(filters.maxPrice !== undefined ? { $lte: filters.maxPrice } : {})
                }
            },
            {
                $and: [
                    { discounted_price: { $exists: false } },
                    {
                        price: {
                            ...(filters.minPrice !== undefined ? { $gte: filters.minPrice } : {}),
                            ...(filters.maxPrice !== undefined ? { $lte: filters.maxPrice } : {})
                        }
                    }
                ]
            }
        ];
    }

    let trendingIds = [];
    if (filters.isTrend) {
        trendingIds = await getTrendingProductIds(10, 3);
        if (trendingIds.length === 0) return { query: { _id: { $in: [] } }, tenDaysAgo, trendingIds };
        query._id = { $in: trendingIds };
    }

    if (filters.isNew == true) {
        query.createdAt = { $gte: tenDaysAgo };
    }

    if (filters.name) {
        query.name = { $regex: filters.name, $options: 'i' };
    }

    if (filters.gender) query.gender = filters.gender;

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
    const tenDaysAgo = new Date();
    tenDaysAgo.setDate(tenDaysAgo.getDate() - 10);

    const trendingIds = await getTrendingProductIds(10, 3);
    const trendingSet = new Set(trendingIds.map(id => id.toString()));

    const product = await Product.findById(_id);

    if (!product) {
        return null;
    }

    const productObject = product.toObject();

    return {
        ...productObject,
        isNew: productObject.createdAt >= tenDaysAgo,
        isTrend: trendingSet.has(productObject._id.toString())
    };
}

async function deleteProducts(productIds) {
    return await Product.deleteMany({ _id: { $in: productIds } });
}

async function getProductsByIds(ids) {
    const tenDaysAgo = new Date();
    tenDaysAgo.setDate(tenDaysAgo.getDate() - 10);

    const trendingIds = await getTrendingProductIds(10, 3);
    const trendingSet = new Set(trendingIds.map(id => id.toString()));

    const products = await Product.find({ _id: { $in: ids } });

    return products.map(p => {
        const obj = p.toObject();
        return {
            ...obj,
            isNew: obj.createdAt >= tenDaysAgo,
            isTrend: trendingSet.has(obj._id.toString())
        };
    });
}

async function incrementInteractionCount(product_id, type, rating_value = null) {
    product = await Product.findOne({ _id: product_id });
    product.interactions[type]++;
    product.interactions.total_interactions++;
    product.total_interaction_score += WEIGHT_MAP[type];
    return await product.save();
}

async function incrementRatingCount(product_id, rating_value) {
    product = await Product.findOne({ _id: product_id });
    product.rating_count++;
    product.rating = (product.rating * product.rating_count + rating_value) / product.rating_count;
    product.total_interaction_score += rating_value;
    return await product.save();
}

async function applyChangedRatingToProduct(product_id, oldRatingValue, rating_value) {
    product = await Product.findOne({ _id: product_id });
    const currentTotalRatingSum = product.rating * product.rating_count;

    product.rating = (currentTotalRatingSum - oldRatingValue + rating_value) / product.rating_count;
    product.rating = parseFloat(product.rating.toFixed(2));
    product.total_interaction_score = product.total_interaction_score - oldRatingValue + rating_value;
    return await product.save();
}

async function getManyProducts(ids) {
    return await Product.find({ _id: { $in: ids } });
}

async function updateProduct(productId, updates) {
    return await Product.findByIdAndUpdate(productId, { $set: updates }, { new: true, runValidators: true });
}

async function decrementQuantity(productId, quantity) {
    return await Product.findByIdAndUpdate(productId, { $inc: { quantity: -quantity } }, { new: true, runValidators: true });
}

async function getLowQuantityProducts(threshold = 50) {
    return await Product.find({ quantity: { $lt: threshold } });
}

async function getRandomProduct() {
    const products = await Product.aggregate([{ $sample: { size: 1 } }]);
    return products[0]._id;
}

module.exports = {
    postProduct,
    getProducts,
    getProductById,
    deleteProducts,
    getProductsCount,
    getProductsByIds,
    incrementInteractionCount,
    incrementRatingCount,
    applyChangedRatingToProduct,
    getManyProducts,
    updateProduct,
    decrementQuantity,
    getLowQuantityProducts,
    getRandomProduct
};
