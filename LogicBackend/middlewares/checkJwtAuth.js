const passport = require('passport');
require('../services/Passport/jwt.strategy')

const requireJwtAuth = passport.authenticate('jwt', { session: false });
module.exports = requireJwtAuth;