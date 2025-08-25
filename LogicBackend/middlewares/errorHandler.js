const { handleErrors } = require('../services/handleErrors')

errorHandler = (err, req, res, next) => {
    const errors = handleErrors(err)
    return res.status(err.statusCode || 500).json({ errors })
}

module.exports = errorHandler