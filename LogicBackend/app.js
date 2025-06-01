const cors = require('cors');
const helmet = require('helmet');
const express = require('express');

const errorHandler = require('./middlewares/errorHandler')
const logger = require('./services/logger');
const app = express();

const cron = require('./services/cron')


app.use(express.json());
app.use(express.urlencoded({ extended: false }))
app.use(logger);

app.use(helmet())
app.use(cors());

// Web
app.use('/auth', require('./routes/Web/Auth/auth.route'))
app.use('/users', require('./routes/Web/Users/users.route'))
app.use('/products', require('./routes/Web/Products/products.route'))
app.use('/favorites', require('./routes/Web/Favorites/favorites.route'))
app.use('/cart', require('./routes/Web/Cart/cart.route'))
app.use('/orders', require('./routes/Web/Orders/orders.route'))
app.use('/payment', require('./routes/Web/Payments/payments.route'))

// Dashboard
app.use('/admin', require('./routes/Dashboard/Admins/admins.route'))
app.use('/products', require('./routes/Dashboard/Products/products.route'))

// Error Handling
app.use(errorHandler);


module.exports = app;