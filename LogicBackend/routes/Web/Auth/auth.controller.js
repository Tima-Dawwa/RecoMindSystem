var path = require('path');
const crypto = require('crypto');
const sendMail = require('../../../services/sendMail');
const { confirmTokenHelper } = require('./auth.helper');
const { postBlacklist } = require('../../../models/blacklist.model');
const { generateToken } = require('../../../services/token')
const { validationErrors } = require('../../../middlewares/validationErrors')
const { postRequest, deleteRequests } = require('../../../models/code_confirmation.model');
const { postUser, getUserByEmail, putPassword } = require('../../../models/users.model');
const { validateRegisterUser, validateLoginUser, validateForgotPassword, validateResetPassword, validateVerifyResetToken } = require('./auth.validation')

require('dotenv').config();

// Done
async function register(req, res) {
    const { error } = validateRegisterUser(req.body)
    if (error) {
        return res.status(400).json({
            errors: validationErrors(error.details)
        })
    }
    req.body.name = { 'first_name': req.body.first_name, 'last_name': req.body.last_name }
    const check = await getUserByEmail(req.body.email)
    if (check) return res.status(400).json({ errors: { email: "Email Already In Use" } })
    const user = await postUser(req.body);

    return res.status(200).json({
        message: 'Successfully Registered',
        token: generateToken({ id: user.id, name: user.name })
    });
}

// Done
async function login(req, res) {
    const { error } = validateLoginUser(req.body);
    if (error) {
        return res.status(400).json({
            errors: validationErrors(error.details)
        });
    }
    const user = await getUserByEmail(req.body.email);
    if (!user) return res.status(400).json({ message: 'Not Registered' });
    if (user) {
        const { id, name } = user;
        const check = await user.checkCredentials(user.password, req.body.password);
        if (check) {
            return res.status(200).json({
                message: 'User Logged In',
                token: generateToken({ id, name }),
            });
        }
    }
    return res.status(400).json({
        message: 'Invalid Credentials',
    });
}

// Done
async function forgotPassword(req, res) {
    const { error } = validateForgotPassword(req.body)
    if (error) {
        return res.status(404).json({
            errors: validationErrors(error.details)
        })
    }
    const user = await getUserByEmail(req.body.email);
    if (!user) {
        return res.status(400).json({ message: 'User Not Found' })
    }

    const token = crypto.randomInt(100000, 999999)

    await deleteRequests(user.id)
    await postRequest({ user_id: user.id, token })

    const name = user.name.first_name + ' ' + user.name.last_name
    const attachments = [{
        filename: 'logo.jpg',
        path: path.join(__dirname, '../../../', 'public', 'images', 'mails', 'logo.png'),
        cid: 'logo'
    }];
    await sendMail('Forgot Password', req.body.email, { name, token, template_name: 'views/forgot_password.html' }, attachments);

    res.status(200).json({ message: 'Check Your Email' })
}

async function verifyResetToken(req, res) {
    const { error } = validateVerifyResetToken(req.body)
    if (error) {
        return res.status(404).json({
            errors: validationErrors(error.details)
        })
    }

    const user = await getUserByEmail(req.body.email);
    if (!user) {
        return res.status(400).json({ message: 'User Not Found' });
    }

    const isValid = await confirmTokenHelper(user, req.body.token);
    if (!isValid) {
        return res.status(400).json({ message: 'Code is Incorrect' });
    }
    return res.status(200).json({ message: 'Token Verified' });
}

// Done
async function resetPassword(req, res) {
    const { error } = validateResetPassword(req.body)
    if (error) {
        return res.status(404).json({
            errors: validationErrors(error.details)
        })
    }
    const user = await getUserByEmail(req.body.email);
    if (!user) {
        return res.status(400).json({ message: 'User Not Found' })
    }

    if (!await confirmTokenHelper(user, req.body.token)) return res.status(400).json({ message: 'Code is Incorrect' })

    await putPassword(user, req.body.password);

    return res.status(200).json({
        message: 'Password Reset Successful',
        token: generateToken({ id: user.id, name: user.name })
    })
}

// Done
async function logout(req, res) {
    const user = req.user;
    const token = req.headers.authorization.split(' ')[1];
    const data = {
        user_id: user.id,
        token_blacklisted: token,
        user_type: 'User'
    }
    await postBlacklist(data)
    return res.status(200).json({ message: 'Logged Out Successfully' })
}


module.exports = {
    register,
    login,
    forgotPassword,
    resetPassword,
    logout,
    verifyResetToken
}