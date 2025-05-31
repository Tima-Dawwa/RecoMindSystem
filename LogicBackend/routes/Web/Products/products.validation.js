const Joi = require('joi');

function validateProductRating(data) {
    const schema = Joi.object({
        rating: Joi.number().min(1).max(5).required(),
    })
    return schema.validate(data);
}

module.exports = {
    validateProductRating
}