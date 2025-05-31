const express = require('express');
const asyncHandler = require('express-async-handler');
const { httpGetAllProducts, httpGetOneProduct, httpGetProductInteractions, httpRateProduct } = require('./products.controller');

const requireJwtAuth = require('../../../middlewares/checkJwtAuth');
const checkObjectID = require('../../../middlewares/checkObjectID');

const productsRouter = express.Router();

productsRouter.get('/', asyncHandler(httpGetAllProducts));
productsRouter.get('/:id', checkObjectID, asyncHandler(httpGetOneProduct));
productsRouter.post('/:id/rate', requireJwtAuth, checkObjectID, asyncHandler(httpRateProduct));

module.exports = productsRouter;