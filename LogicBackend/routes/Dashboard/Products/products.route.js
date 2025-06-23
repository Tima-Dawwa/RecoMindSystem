const express = require('express');
const asyncHandler = require('express-async-handler');
const { httpGetAllProducts, httpGetOneProduct, httpPostProduct, httpDeleteProduct, httpPutProduct } = require('./products.controller');

const requireJwtAuth = require('../../../middlewares/checkJwtAuth');
const checkObjectID = require('../../../middlewares/checkObjectID');
const upload = require('../../../services/imageUploading');

const productsRouter = express.Router();

productsRouter.get('/', asyncHandler(httpGetAllProducts));
productsRouter.get('/:id', checkObjectID, asyncHandler(httpGetOneProduct));
productsRouter.post('/', upload.array('images'), asyncHandler(httpPostProduct));
productsRouter.delete('/', asyncHandler(httpDeleteProduct));
productsRouter.put('/:id', checkObjectID, upload.array('images'), asyncHandler(httpPutProduct));

module.exports = productsRouter;