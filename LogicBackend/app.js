const cors = require('cors');
const helmet = require('helmet');
const express = require('express');
// const rateLimit = require('express-rate-limit');

const errorHandler = require('./middlewares/errorHandler');
const logger = require('./services/logger');
const app = express();

const cron = require('./services/cron');

app.use(helmet());
app.use(cors());

// const generalLimiter = rateLimit({
//     windowMs: 1 * 60 * 1000,
//     max: 200,
//     handler: (req, res, next, options) => {
//         res.status(options.statusCode).json({
//             success: false,
//             message: 'Too many requests, please try again later.',
//             limit: options.max,
//             windowMs: options.windowMs
//         });
//     }
// });
// app.use(generalLimiter);

var path = require('path');
// Images
app.use(express.static(path.resolve('./public')));
app.use('/public', express.static(path.resolve('./public')));

app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(logger);

// Web
app.use('/auth', require('./routes/Web/Auth/auth.route'));
app.use('/users', require('./routes/Web/Users/users.route'));
app.use('/products', require('./routes/Web/Products/products.route'));
app.use('/favorites', require('./routes/Web/Favorites/favorites.route'));
app.use('/cart', require('./routes/Web/Cart/cart.route'));
app.use('/orders', require('./routes/Web/Orders/orders.route'));
app.use('/payment', require('./routes/Web/Payments/payments.route'));
app.use('/chats', require('./routes/Web/Chat/chats.route'));

// Dashboard
app.use('/dashboard/admins', require('./routes/Dashboard/Admins/admins.route'));
app.use('/dashboard/products', require('./routes/Dashboard/Products/products.route'));
app.use('/dashboard/orders', require('./routes/Dashboard/Orders/orders.route'));
app.use('/dashboard/notifications', require('./routes/Dashboard/Notifications/notifications.route'));
app.use('/dashboard/statistics', require('./routes/Dashboard/Statistics/statistics.route'));

// Error Handling
app.use(errorHandler);

module.exports = app;
