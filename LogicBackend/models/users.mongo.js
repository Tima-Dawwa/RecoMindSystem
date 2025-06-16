const mongoose = require('mongoose');
const { isEmail } = require('validator');
const bcryptjs = require('bcryptjs');

const contactSchema = require('./contact.mongo');

const userSchema = new mongoose.Schema({
    name: {
        first_name: {
            type: String,
            required: [true, 'First Name Required'],
            minlength: 2,
            maxlength: 25,
        },
        last_name: {
            type: String,
            required: [true, 'Last Name Required'],
            minlength: 2,
            maxlength: 25,
        }
    },
    email: {
        type: String,
        required: [true, 'Email Required'],
        unique: [true, 'Email Already Registered'],
        lowercase: true,
        validate: [isEmail, 'Enter a Valid Email Adress'],
        minlength: 5,
        maxlength: 100,
        trim: true,
    },
    phone: {
        type: contactSchema
    },
    location: {
        country: String,
        city: String
    },
    password: {
        type: String,
        required: [true, 'Password Required'],
        minlength: [8, 'Password must be atleast 8 characters long'],
        trim: true,
    },
    gender: {
        type: String,
        enum: ["Male", "Female"]
    },
    date_of_birth: {
        type: Date,
    },
}, { timestamps: true })

userSchema.pre('save', async function (next) {
    if (this.isModified('password')) {
        const salt = await bcryptjs.genSalt(10);
        this.password = await bcryptjs.hash(this.password, salt);
    }
    next();
})

userSchema.methods.checkCredentials = async function (hashed, password) {
    return await bcryptjs.compare(password, hashed);
}

module.exports = mongoose.model('User', userSchema);