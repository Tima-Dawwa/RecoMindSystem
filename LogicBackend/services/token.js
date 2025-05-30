const jwt = require('jsonwebtoken');
const bcryptjs = require('bcryptjs');
require('dotenv').config();
const SECRET_KEY = process.env.SECRET_KEY;
const maxAge = '3d';

function generateToken(payload, secret = SECRET_KEY, expiresIn = maxAge) {
    return jwt.sign(payload, secret, { expiresIn: expiresIn });
}

async function checkCredentials(hashed, password) {
    return await bcryptjs.compare(password, hashed);
}

function verifyToken(token, secret) {
    return jwt.verify(token, secret)
}

module.exports = {
    generateToken,
    checkCredentials,
    verifyToken
}