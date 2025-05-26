const express = require('express');
const asyncHandler = require('express-async-handler');

const requireJwtAuth = require('../../../middlewares/checkJwtAuth');
const checkObjectID = require('../../../middlewares/checkObjectID');
const { httpGetOrders, httpGetOrder, httpPostOrder,httpAddOrder } = require('./orders.controller');

const ordersRouter = express.Router();

ordersRouter.get('/', requireJwtAuth, asyncHandler(httpGetOrders));
ordersRouter.post('/', requireJwtAuth, asyncHandler(httpPostOrder));
ordersRouter.get('/:id', requireJwtAuth, checkObjectID, asyncHandler(httpGetOrder));

ordersRouter.post('/:id/order', requireJwtAuth, checkObjectID, asyncHandler(httpAddOrder));
module.exports = ordersRouter;