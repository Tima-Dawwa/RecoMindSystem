const Joi = require('joi');

const contactSchema = Joi.object({
    country_code: Joi.string().required().messages({
        'any.required': 'Country Code Required To Change',
        'string.base': 'Country Code must be a string'
    }),
    number: Joi.string().required().messages({
        'any.required': 'Number Required To Change',
        'string.base': 'Number must be a string'
    })
});


function validateRegisterUser(user) {
    const schema = Joi.object({
        first_name: Joi.string().required().messages({
            'any.required': "Name Required",
        }),
        last_name: Joi.string().required().messages({
            'any.required': "Name Required",
        }),
        email: Joi.string().min(3).required().email().messages({
            'any.required': "Email Required",
            'string.email': "Email Must Be Valid"
        }),
        password: Joi.string().min(8).max(25).required().label('Password').messages({
            'any.required': "Password Required",
            'string.min': "Password Must Be 8 Characters"
        }),
        password_confirmation: Joi.any().equal(Joi.ref('password'))
            .required()
            .label('Confirm password')
            .messages({ 'any.only': '{{#label}} does not match' }),
        date_of_birth: Joi.date().required().messages({
            'any.required': 'Date Required'
        }),
        gender: Joi.string().valid('Male', 'Female').required().messages({
            'any.required': 'Gender Required'
        }),
        phone: contactSchema.required().messages({
            'any.required': 'Phone required'
        })

    })
    return schema.validate(user, { abortEarly: false });
}

function validateLoginUser(user) {
    const schema = Joi.object({
        email: Joi.string().min(3).required().messages({
            'any.required': "Email Required",
        }),
        password: Joi.string().required().messages({
            'any.required': "Password Required",
        }),
    })
    return schema.validate(user);
}

function validateForgotPassword(user) {
    const schema = Joi.object({
        email: Joi.string().min(3).required(),
    })
    return schema.validate(user);
}

function validateResetPassword(user) {
    const schema = Joi.object({
        email: Joi.string().min(3).required(),
        token: Joi.number().required(),
        password: Joi.string().min(8).required(),
        confirm_password: Joi.any().valid(Joi.ref('password')).required().label('Confirm password').messages({ 'any.only': 'Passwords do not match' })
    })
    return schema.validate(user);
}

function validateVerifyResetToken(data) {
    const schema = Joi.object({
        email: Joi.string().min(3).required(),
        token: Joi.string().length(6).required()
    })
    return schema.validate(data);
}

module.exports = {
    validateRegisterUser,
    validateLoginUser,
    validateForgotPassword,
    validateResetPassword,
    validateVerifyResetToken
}