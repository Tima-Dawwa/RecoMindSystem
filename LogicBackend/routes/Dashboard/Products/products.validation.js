const Joi = require('joi');

function validateCreateProduct(product) {
    const schema = Joi.object({
        name: Joi.string().trim().required(),
        details: Joi.string().trim().required(),
        type: Joi.string().trim().required(),
        appearance: Joi.string().trim().required(),
        department: Joi.string().trim().required(),
        color: Joi.string().trim().required(),
        gender: Joi.string().required(),
        price: Joi.number().min(0).required(),
        discounted_price: Joi.number().min(0).max(Joi.ref('price')).optional(),
        quantity: Joi.number().integer().min(0).required()
    });

    return schema.validate(product, { abortEarly: false });
}

function validateEditProduct(product) {
    const schema = Joi.object({
        name: Joi.string().trim().required(),
        details: Joi.string().trim().required(),
        type: Joi.string().trim().required(),
        appearance: Joi.string().trim().required(),
        department: Joi.string().trim().required(),
        color: Joi.string().trim().required(),
        gender: Joi.string().required(),
        price: Joi.number().min(0).required(),
        discounted_price: Joi.number().min(0).max(Joi.ref('price')).optional(),
        quantity: Joi.number().integer().min(0).required(),
        imagesToKeep: Joi.array().items(Joi.string().trim()).required()
    });

    return schema.validate(product, { abortEarly: false });
}

module.exports = { validateCreateProduct, validateEditProduct };
