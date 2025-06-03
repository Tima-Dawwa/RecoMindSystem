const JWT_SECRET = process.env.SECRET_KEY;
const { verifyToken } = require('../services/token');

module.exports = async (req, res, next) => {
    const authHeader = req.headers.authorization;

    if (authHeader && authHeader.startsWith('Bearer ')) {
        const token = authHeader.split(' ')[1];
        if (token) {
            try {
                const decoded = verifyToken(token, JWT_SECRET)
                req.user = decoded;
            } catch (error) {
                console.warn('Optional auth: Invalid token received - ', error.message);
            }
        }
    }
    next();
};