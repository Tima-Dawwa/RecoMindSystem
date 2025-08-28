const express = require('express');
const asyncHandler = require('express-async-handler');
const { httpGetAllProducts, httpGetOneProduct, httpPostProduct, httpDeleteProduct, httpPutProduct } = require('./products.controller');

const requireJwtAuth = require('../../../middlewares/checkJwtAuth');
const checkSuperAdmin = require('../../../middlewares/checkSuperAdmin');
const checkObjectID = require('../../../middlewares/checkObjectID');
const upload = require('../../../services/imageUploading');

const productsRouter = express.Router();

productsRouter.get('/', requireJwtAuth, checkSuperAdmin, asyncHandler(httpGetAllProducts));
productsRouter.get('/:id', requireJwtAuth, checkSuperAdmin, checkObjectID, asyncHandler(httpGetOneProduct));
productsRouter.post('/', requireJwtAuth, checkSuperAdmin, upload.array('images'), asyncHandler(httpPostProduct));
productsRouter.delete('/', requireJwtAuth, checkSuperAdmin, asyncHandler(httpDeleteProduct));
productsRouter.put('/:id', requireJwtAuth, checkSuperAdmin, checkObjectID, upload.array('images'), asyncHandler(httpPutProduct));

module.exports = productsRouter;
