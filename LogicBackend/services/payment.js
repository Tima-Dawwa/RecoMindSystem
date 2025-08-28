require('dotenv').config();
const URL = process.env.URL;

function createPaymentData(cart, amount, type) {
    const currency = 'USD';

    const items = cart.items.map(item => ({
        name: item.product.name || `Product ${item.product._id}`,
        sku: item.product._id.toString(),
        price: item.price.toFixed(2),
        currency: currency,
        quantity: item.quantity
    }));

    const total = cart.total_price.toFixed(2);
    const payment_data = {
        intent: 'sale',
        payer: {
            payment_method: 'paypal'
        },
        redirect_urls: {
            // "return_url": `http://localhost:5000/payment/execute_payment?amount=${amount}&currency=${currency}`,
            // "cancel_url": "http://localhost:5000/payment/cancel"
            return_url: `${URL}/payment/execute_payment?amount=${amount}&currency=${currency}`,
            cancel_url: `${URL}/payment/cancel`
        },
        transactions: [
            {
                item_list: {
                    items: items
                },
                amount: {
                    currency: currency,
                    total: total
                },
                description: 'This is the payment for ' + type
            }
        ]
    };
    return payment_data;
}

module.exports = createPaymentData;
