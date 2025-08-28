const express = require('express');
const asyncHandler = require('express-async-handler');

const requireJwtAuth = require('../../../middlewares/checkJwtAuth');
const checkSuperAdmin = require('../../../middlewares/checkSuperAdmin')
const checkAdmin = require('../../../middlewares/checkAdmin')
const checkObjectID = require('../../../middlewares/checkObjectID');

const statisticsRouter = express.Router();


module.exports = statisticsRouter;