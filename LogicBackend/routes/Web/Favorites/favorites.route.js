const express = require('express');
const asyncHandler = require('express-async-handler');
const { httpGetFavorites, httpAddFavorite, httpRemoveFavorite } = require('./favorites.controller');

const requireJwtAuth = require('../../../middlewares/checkJwtAuth');
const checkObjectID = require('../../../middlewares/checkObjectID');

const favoritesRouter = express.Router();

favoritesRouter.get('/', requireJwtAuth, asyncHandler(httpGetFavorites));
favoritesRouter.post('/:id', requireJwtAuth, checkObjectID, asyncHandler(httpAddFavorite));
favoritesRouter.delete('/:id', requireJwtAuth, checkObjectID, asyncHandler(httpRemoveFavorite));

module.exports = favoritesRouter;