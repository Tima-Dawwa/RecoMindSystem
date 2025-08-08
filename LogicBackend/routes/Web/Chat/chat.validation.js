const Joi = require('joi');

function validateSendMessage(data) {
    const schema = Joi.object({
        message: Joi.string().messages({
            'any.required': "Message Required",
            "string.empty": "Message Not Allowed To Be Empty"
        }),
    })
    return schema.validate(data);
}

module.exports = {
    validateSendMessage,
}