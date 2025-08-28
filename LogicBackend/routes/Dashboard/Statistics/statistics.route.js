const express = require('express');
const asyncHandler = require('express-async-handler');

const requireJwtAuth = require('../../../middlewares/checkJwtAuth');
const checkSuperAdmin = require('../../../middlewares/checkSuperAdmin')

const { getChatbotSimilarityStatistics, getChatbotResponseTimeStatistics, getRecommendationSimilarityStatistics, getRecommendationResponseTimeStatistics } = require('./statistics.controller');

const statisticsRouter = express.Router();

statisticsRouter.get('/chatbot/similarity', requireJwtAuth, checkSuperAdmin, asyncHandler(getChatbotSimilarityStatistics));
statisticsRouter.get('/chatbot/response-time', requireJwtAuth, checkSuperAdmin, asyncHandler(getChatbotResponseTimeStatistics));
statisticsRouter.get('/recommendation/similarity', requireJwtAuth, checkSuperAdmin, asyncHandler(getRecommendationSimilarityStatistics));
statisticsRouter.get('/recommendation/response-time', requireJwtAuth, checkSuperAdmin, asyncHandler(getRecommendationResponseTimeStatistics));

module.exports = statisticsRouter;