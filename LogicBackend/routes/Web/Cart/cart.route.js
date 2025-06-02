const express = require('express');
const asyncHandler = require('express-async-handler');
const { httpGetCart, httpAddToCart, httpRemoveFromCart } = require('./cart.controller');

const requireJwtAuth = require('../../../middlewares/checkJwtAuth');
const checkObjectID = require('../../../middlewares/checkObjectID');

const cartRouter = express.Router();

cartRouter.get('/', requireJwtAuth, asyncHandler(httpGetCart));
cartRouter.post('/:id', requireJwtAuth, checkObjectID, asyncHandler(httpAddToCart));
cartRouter.delete('/:id', requireJwtAuth, checkObjectID, asyncHandler(httpRemoveFromCart));

module.exports = cartRouter;