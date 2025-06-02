const express = require('express');
const asyncHandler = require('express-async-handler');
const { httpGetAllProducts, httpGetOneProduct, httpRateProduct } = require('./products.controller');

const requireJwtAuth = require('../../../middlewares/checkJwtAuth');
const optionalJwtAuth = require('../../../middlewares/optionalJwtAuth');
const checkObjectID = require('../../../middlewares/checkObjectID');

const productsRouter = express.Router();

productsRouter.get('/', asyncHandler(httpGetAllProducts));
productsRouter.get('/:id', optionalJwtAuth, checkObjectID, asyncHandler(httpGetOneProduct));
productsRouter.post('/:id/rate', requireJwtAuth, checkObjectID, asyncHandler(httpRateProduct));

module.exports = productsRouter;