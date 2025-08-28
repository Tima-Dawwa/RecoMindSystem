function userData(user) {
    return {
        name: user.name,
        email: user.email,
        gender: user.gender,
        location: user.location,
        phone_number: user.phone,
        date_of_birth: user.date_of_birth,
        profile_pic: user.profile_pic
    };
}

module.exports = {
    userData
};
