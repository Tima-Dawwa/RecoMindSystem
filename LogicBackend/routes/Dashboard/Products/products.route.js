const express = require('express');
const asyncHandler = require('express-async-handler');
const { httpGetAllProducts, httpGetOneProduct, httpPostProduct, httpDeleteProduct } = require('./products.controller');

const requireJwtAuth = require('../../../middlewares/checkJwtAuth');
const checkObjectID = require('../../../middlewares/checkObjectID');

const productsRouter = express.Router();

productsRouter.get('/products', requireJwtAuth, asyncHandler(httpGetAllProducts));
productsRouter.get('/products/:id', requireJwtAuth, checkObjectID, asyncHandler(httpGetOneProduct));
productsRouter.post('/products', requireJwtAuth, asyncHandler(httpPostProduct));
productsRouter.delete('/products/:id', requireJwtAuth, checkObjectID, asyncHandler(httpDeleteProduct));

module.exports = productsRouter;