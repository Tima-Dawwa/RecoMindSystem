const express = require('express');
const asyncHandler = require('express-async-handler');
const { httpGetAllProducts, httpGetOneProduct } = require('./products.controller');

const requireJwtAuth = require('../../../middlewares/checkJwtAuth');
const checkObjectID = require('../../../middlewares/checkObjectID');

const productsRouter = express.Router();

productsRouter.get('/products', requireJwtAuth, asyncHandler(httpGetAllProducts));
productsRouter.get('/products/:id', requireJwtAuth, checkObjectID, asyncHandler(httpGetOneProduct));

module.exports = productsRouter;