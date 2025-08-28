const express = require('express');
const asyncHandler = require('express-async-handler');

const requireJwtAuth = require('../../../middlewares/checkJwtAuth');
const checkObjectID = require('../../../middlewares/checkObjectID');
const { httpGetOrders, httpGetOrder, httpGetOrdersStatistics, httpUpdateOrderStatus } = require('./orders.controller');

const ordersRouter = express.Router();

ordersRouter.get('/', requireJwtAuth, asyncHandler(httpGetOrders));
ordersRouter.get('/statistics', requireJwtAuth, asyncHandler(httpGetOrdersStatistics));
ordersRouter.get('/:id', requireJwtAuth, checkObjectID, asyncHandler(httpGetOrder));
ordersRouter.put('/:orderId/status', requireJwtAuth, checkObjectID, asyncHandler(httpUpdateOrderStatus));

module.exports = ordersRouter;
