const express = require('express');
const asyncHandler = require('express-async-handler');
const { httpGetAllProducts, httpGetOneProduct,httpGetProductInteractions } = require('./products.controller');

const requireJwtAuth = require('../../../middlewares/checkJwtAuth');
const checkObjectID = require('../../../middlewares/checkObjectID');

const productsRouter = express.Router();

productsRouter.get('/', requireJwtAuth, asyncHandler(httpGetAllProducts));
productsRouter.get('/:id', checkObjectID, asyncHandler(httpGetOneProduct));
productsRouter.get('/:id/interactions', requireJwtAuth, checkObjectID, asyncHandler(httpGetProductInteractions));

module.exports = productsRouter;