const express = require('express');
const asyncHandler = require('express-async-handler');

const requireJwtAuth = require('../../../middlewares/checkJwtAuth');
const checkObjectID = require('../../../middlewares/checkObjectID');
const { httpGetOrders, httpGetOrder } = require('./orders.controller');

const ordersRouter = express.Router();

ordersRouter.get('/', requireJwtAuth, asyncHandler(httpGetOrders));

module.exports = ordersRouter;