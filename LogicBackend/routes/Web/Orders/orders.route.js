const express = require('express');
const asyncHandler = require('express-async-handler');

const requireJwtAuth = require('../../../middlewares/checkJwtAuth');
const checkObjectID = require('../../../middlewares/checkObjectID');

const { httpGetOrders, httpGetOrder, httpPostOrder } = require('./orders.controller');


const ordersRouter = express.Router();

ordersRouter.get('/', requireJwtAuth, asyncHandler(httpGetOrders));
ordersRouter.get('/:id', requireJwtAuth, checkObjectID, asyncHandler(httpGetOrder));
ordersRouter.post('/', requireJwtAuth, asyncHandler(httpPostOrder));

module.exports = ordersRouter;