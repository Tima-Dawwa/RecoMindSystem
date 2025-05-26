const Product = require('./products.mongo');
const { getTrendingProductIds } = require('../models/orders.model');

async function postProduct(data) {
    return await Product.create(data);
}

async function buildProductQuery(filters) {
    const query = {};
    const tenDaysAgo = new Date();
    tenDaysAgo.setDate(tenDaysAgo.getDate() - 10);

    if (filters.category) query.gender = filters.category;

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

module.exports = {
    postProduct,
    getProducts,
    getProductById,
    deleteProduct,
    getProductsCount,
    getProductsByIds
}