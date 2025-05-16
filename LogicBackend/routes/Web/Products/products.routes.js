const express = require('express');
const { httpGetAllProducts, httpGetProductById, httpGetProductInteractions } = require('./products.controller');
const { authenticateUser } = require('../../../middlewares/auth');

const router = express.Router();

router.get('/', httpGetAllProducts);
router.get('/:id', httpGetProductById);
router.get('/:id/interactions', authenticateUser, httpGetProductInteractions);

module.exports = router; 