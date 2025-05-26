const express = require('express');
const asyncHandler = require('express-async-handler');
const { httpGetFavorites, httpAddFavorite, httpRemoveFavorite } = require('./favorites.controller');

const requireJwtAuth = require('../../../middlewares/checkJwtAuth');
const checkObjectID = require('../../../middlewares/checkObjectID');

const favoritesRouter = express.Router();

favoritesRouter.get('/favorites', requireJwtAuth, asyncHandler(httpGetFavorites));
favoritesRouter.post('/favorites/:id', requireJwtAuth, checkObjectID, asyncHandler(httpAddFavorite));
favoritesRouter.delete('/favorites/:id', requireJwtAuth, checkObjectID, asyncHandler(httpRemoveFavorite));
favoritesRouter.post('/:id/favorite', requireJwtAuth, checkObjectID, asyncHandler(httpAddFavorite));

module.exports = favoritesRouter;