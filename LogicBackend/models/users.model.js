const User = require('./users.mongo');

async function postUser(data) {
    return await User.create(data);
}

async function getUserByEmail(email) {
    return await User.findOne({ email });
}

async function getUserById(_id) {
    return await User.find({ _id })
}

async function deleteAccount(user_id) {
    return await User.deleteOne({ _id: user_id });
}

async function putName(user, name) {
    user.name.first_name = name.first_name;
    user.name.last_name = name.last_name;
    return await user.save();
}

async function putGender(user, gender) {
    user.gender = gender;
    return await user.save();
}

async function putDate(user, date) {
    user.date_of_birth = date;
    return await user.save();
}

async function putPhoneNumber(user, phone_number) {
    user.phone = phone_number;
    return await user.save();
}

async function putPassword(user, password) {
    user.password = password;
    return await user.save();
}

async function putLocation(user, location) {
    user.location = location;
    return await user.save();
}


function checkConfirmed(user) {
    return user.email_confirmed == true;
}

async function putEmailConfirmation(user) {
    user.email_confirmed = true;
    await user.save();
}


module.exports = {
    postUser,
    putName,
    putGender,
    putDate,
    putPhoneNumber,
    putPassword,
    putLocation,
    putEmailConfirmation,
    checkConfirmed,
    deleteAccount,
    getUserById,
    getUserByEmail
}