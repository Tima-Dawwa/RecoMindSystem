var path = require('path');
const crypto = require('crypto');
const { userData } = require('./users.serializer');
const { validationErrors } = require('../../../middlewares/validationErrors')
const { putName, putGender, putDate, putProfilePic, getProfile, putLocation, putPassword, deleteAccount, putPhoneNumber } = require('../../../models/users.model');
const { validateChangeName, validateChangeGender, validateChangeDate, validateChangeLocation, validateChangePassword, validateDeleteAccount, validateChangePhoneNumber, validateCheckTokenToDelete } = require('./users.validation');
const { postRequest, deleteRequests } = require('../../../models/code_confirmation.model');
const { confirmTokenHelper } = require('../Auth/auth.helper');
const sendMail = require('../../../services/sendMail');

async function httpGetProfile(req, res) {
    const user = req.user;
    if (!user) return res.status(400).json({ message: 'User Not Found' })
    const profile = await getProfile(user._id);
    return res.status(200).json({
        message: 'Profile Retreived',
        profile: userData(profile)
    })
}

async function httpPutName(req, res) {
    const { error } = await validateChangeName(req.body)
    if (error) {
        return res.status(400).json({ message: validationErrors(error.details) })
    }
    const user = req.user;
    if (!user) return res.status(400).json({ message: 'User Not Found' })
    const name = { first_name: req.body.first_name, last_name: req.body.last_name }
    await putName(user, name);
    return res.status(200).json({
        message: 'Name Changed',
        name: user.name
    })
}

async function httpPutGender(req, res) {
    const { error } = await validateChangeGender(req.body)
    if (error) {
        return res.status(400).json({ message: validationErrors(error.details) })
    }
    const user = req.user;
    if (!user) return res.status(400).json({ message: 'User Not Found' })
    const gender = await putGender(user, req.body.gender);
    return res.status(200).json({
        message: 'Gender Changed',
        gender
    })
}

async function httpPutDate(req, res) {
    const { error } = await validateChangeDate(req.body)
    if (error) {
        return res.status(400).json({ message: validationErrors(error.details) })
    }
    const user = req.user;
    if (!user) return res.status(400).json({ message: 'User Not Found' })
    const { date_of_birth } = await putDate(user, req.body.date);
    return res.status(200).json({
        message: 'Date Changed',
        date_of_birth
    })
}

async function httpPutLocation(req, res) {
    const { error } = await validateChangeLocation(req.body)
    if (error) {
        return res.status(400).json({ message: validationErrors(error.details) })
    }
    const user = req.user;
    if (!user) return res.status(400).json({ message: 'User Not Found' })
    const { location } = await putLocation(user, { city: req.body.city, country: req.body.countDocumentsry });
    return res.status(200).json({
        message: 'Location Changed',
        location
    })
}

async function httpPutProfilePic(req, res) {
    const user = req.user;
    if (!user) return res.status(400).json({ message: 'User Not Found' })
    if (!req.file) {
        return res.status(404).json({ message: 'Image Not Found' });
    }
    await putProfilePic(user, req.file.filename)
    return res.status(200).json({ message: 'Profile Picture Updated Successfully' });
}

async function httpPutPhoneNumber(req, res) {
    const { error } = await validateChangePhoneNumber(req.body)
    if (error) {
        return res.status(400).json({ message: validationErrors(error.details) })
    }
    const user = req.user;
    if (!user) return res.status(400).json({ message: 'User Not Found' })
    const data = {
        country_code: req.body.countDocumentsry_code,
        number: req.body.number,
    }
    await putPhoneNumber(user, data)
    return res.status(200).json({ message: 'Phone Number Updated Successfully' });
}

async function httpPutPassword(req, res) {
    const { error } = await validateChangePassword(req.body);
    if (error) return res.status(400).json({ message: error.details[0].message })

    const user = req.user
    if (!user) return res.status(400).json({ message: 'User Not Found' })
    const check = await user.checkCredentials(user.password, req.body.old_password);
    if (!check) return res.status(400).json({ message: 'Old Password Does Not Match' })
    await putPassword(user, req.body.new_password)
    return res.status(200).json({ message: 'Password Updated Successfully' })
}

async function httpRequestDeleteAccount(req, res) {
    const { error } = await validateDeleteAccount(req.body);
    if (error) return res.status(400).json({ message: validationErrors(error.details) })

    const user = req.user;
    if (!user) return res.status(400).json({ message: 'User Not Found' })

    const check = await user.checkCredentials(user.password, req.body.password)


    const token = crypto.randomInt(100000, 999999)
    await deleteRequests(user.id)
    await postRequest({ user_id: user.id, token })
    const name = user.name.first_name + ' ' + user.name.last_name
    const attachments = [{
        filename: 'logo.jpg',
        path: path.join(__dirname, '../../../', 'public', 'images', 'mails', 'logo.png'),
        cid: 'logo'
    }];
    await sendMail('Delete Account Request', user.email, { name, token, template_name: 'views/delete_account.html' }, attachments);

    if (!check) return res.status(400).json({ message: 'Incorrect Password', check: false })
    else return res.status(200).json({ message: 'An Email Has Been Sent', check: true })
}

async function httpDeleteAccount(req, res) {
    const { error } = await validateCheckTokenToDelete(req.body);
    if (error) return res.status(400).json({ message: validationErrors(error.details) })

    const user = req.user
    if (!await confirmTokenHelper(user, req.body.token)) return res.status(400).json({ message: 'Code is Incorrect' })
    await deleteAccount(user._id);

    return res.status(200).json({ message: 'Account Has Been Deleted' })
}


module.exports = {
    httpPutName,
    httpPutGender,
    httpPutDate,
    httpPutProfilePic,
    httpPutPhoneNumber,
    httpGetProfile,
    httpPutLocation,
    httpPutPassword,
    httpDeleteAccount,
    httpRequestDeleteAccount
}