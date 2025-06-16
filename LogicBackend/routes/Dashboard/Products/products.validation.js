const Joi = require('joi');

function validateCreateProduct(product) {
    const schema = Joi.object({

    });
    return schema.validate(product, { abortEarly: false });
}

module.exports = {
    validateCreateProduct
}