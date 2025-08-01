const express = require('express')
const asyncHandler = require('express-async-handler');
const { httpGetAllNotifications } = require('./notifications.controller');

const requireJwtAuth = require('../../../middlewares/checkJwtAuth');
const checkAdmin = require('../../../middlewares/checkAdmin');

const notificationsRouter = express.Router();

notificationsRouter.get('/notifications', requireJwtAuth, checkAdmin, asyncHandler(httpGetAllNotifications))

module.exports = notificationsRouter;