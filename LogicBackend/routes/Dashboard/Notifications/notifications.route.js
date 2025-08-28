const express = require('express');
const asyncHandler = require('express-async-handler');
const { httpGetAllNotifications, httpDeleteNotification } = require('./notifications.controller');

const requireJwtAuth = require('../../../middlewares/checkJwtAuth');
const checkAdmin = require('../../../middlewares/checkAdmin');
const checkObjectID = require('../../../middlewares/checkObjectID');

const notificationsRouter = express.Router();

notificationsRouter.get('/', requireJwtAuth, checkAdmin, asyncHandler(httpGetAllNotifications));
notificationsRouter.delete('/:id', requireJwtAuth, checkAdmin, checkObjectID, asyncHandler(httpDeleteNotification));

module.exports = notificationsRouter;
