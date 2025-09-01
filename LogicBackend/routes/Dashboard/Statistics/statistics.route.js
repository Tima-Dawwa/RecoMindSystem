const express = require('express');
const asyncHandler = require('express-async-handler');

const requireJwtAuth = require('../../../middlewares/checkJwtAuth');
const checkSuperAdmin = require('../../../middlewares/checkSuperAdmin');

const {
    getChatbotSimilarityStatistics,
    getChatbotResponseTimeStatistics,
    getRecommendationSimilarityStatistics,
    getRecommendationResponseTimeStatistics,
    getSalesOverTime,
    httpGetMostFavoritedProduct,
    httpGetChatbotUsageType,
    httpGetMostUsersByCountry,
    httpGetTopCustomersByOrders,
    httpGetTopCustomersByInteractions
} = require('./statistics.controller');

const statisticsRouter = express.Router();

statisticsRouter.get('/chatbot/similarity', requireJwtAuth, checkSuperAdmin, asyncHandler(getChatbotSimilarityStatistics));
statisticsRouter.get('/chatbot/response-time', requireJwtAuth, checkSuperAdmin, asyncHandler(getChatbotResponseTimeStatistics));
statisticsRouter.get('/recommendation/similarity', requireJwtAuth, checkSuperAdmin, asyncHandler(getRecommendationSimilarityStatistics));
statisticsRouter.get('/recommendation/response-time', requireJwtAuth, checkSuperAdmin, asyncHandler(getRecommendationResponseTimeStatistics));

// new
statisticsRouter.get('/sales', requireJwtAuth, checkSuperAdmin, asyncHandler(getSalesOverTime));
statisticsRouter.get('/favorites', requireJwtAuth, checkSuperAdmin, asyncHandler(httpGetMostFavoritedProduct));
statisticsRouter.get('/chatbot', requireJwtAuth, checkSuperAdmin, asyncHandler(httpGetChatbotUsageType));
statisticsRouter.get('/top-countries', requireJwtAuth, checkSuperAdmin, asyncHandler(httpGetMostUsersByCountry));
statisticsRouter.get('/top-customers/orders', requireJwtAuth, checkSuperAdmin, asyncHandler(httpGetTopCustomersByOrders));
statisticsRouter.get('/top-customers/interactions', requireJwtAuth, checkSuperAdmin, asyncHandler(httpGetTopCustomersByInteractions));

module.exports = statisticsRouter;
