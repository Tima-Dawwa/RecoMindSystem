const express = require('express');
const asyncHandler = require('express-async-handler');

const requireJwtAuth = require('../../../middlewares/checkJwtAuth');
const { httpGetAllChats, httpPostChat } = require('./chats.controller');

const chatRouter = express.Router();

chatRouter.get('/', requireJwtAuth, asyncHandler(httpGetAllChats));
chatRouter.post('/create', requireJwtAuth, asyncHandler(httpPostChat));

module.exports = chatRouter;
