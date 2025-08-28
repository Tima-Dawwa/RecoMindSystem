const express = require('express');
const asyncHandler = require('express-async-handler');

const requireJwtAuth = require('../../../middlewares/checkJwtAuth');
const checkSuperAdmin = require('../../../middlewares/checkSuperAdmin')

const { getChatbotSimilarityStatsController, getChatbotResponseTimeStatsController, getRecommendationSimilarityStatsController, getRecommendationResponseTimeStatsController } = require('./statistics.controller');

const statisticsRouter = express.Router();

statisticsRouter.get('/chatbot/similarity', requireJwtAuth, checkSuperAdmin, asyncHandler(getChatbotSimilarityStatsController));
statisticsRouter.get('/chatbot/response-time', requireJwtAuth, checkSuperAdmin, asyncHandler(getChatbotResponseTimeStatsController));
statisticsRouter.get('/recommendation/similarity', requireJwtAuth, checkSuperAdmin, asyncHandler(getRecommendationSimilarityStatsController));
statisticsRouter.get('/recommendation/response-time', requireJwtAuth, checkSuperAdmin, asyncHandler(getRecommendationResponseTimeStatsController));

module.exports = statisticsRouter;