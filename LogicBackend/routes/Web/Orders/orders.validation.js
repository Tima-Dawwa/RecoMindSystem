const Joi = require('joi');

function validatePostOrder(data) {
    const schema = Joi.object({
        items: Joi.array()
            .items(
                Joi.object({
                    product: Joi.string().hex().length(24).required(),
                    quantity: Joi.number().integer().min(1).required(),
                    price: Joi.number().precision(2).min(0).required()
                })
            )
            .min(1)
            .required(),

        total_price: Joi.number().precision(2).min(0).required()
    });
    return schema.validate(data);
}

module.exports = {
    validatePostOrder
};
