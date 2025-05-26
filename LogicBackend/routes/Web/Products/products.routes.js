const express = require('express');
const { 
    httpGetAllProducts, 
    httpGetOneProduct, 
    httpGetProductInteractions,
    httpRateProduct 
} = require('./products.controller');
const { authenticateUser } = require('../../../middleware/auth');

const productsRouter = express.Router();

productsRouter.get('/', httpGetAllProducts);
productsRouter.get('/:id', authenticateUser, httpGetOneProduct);
productsRouter.get('/:id/interactions', authenticateUser, httpGetProductInteractions);
productsRouter.post('/:id/rate', authenticateUser, httpRateProduct);

module.exports = productsRouter; 