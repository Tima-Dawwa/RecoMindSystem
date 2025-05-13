function handleErrors(err) {
    const errors = {};

    // Handle duplicate key error (MongoDB code 11000)
    if (err.code === 11000) {
        const field = Object.keys(err.keyPattern)[0];
        errors[field] = `${field} is already being used`;
        return errors;
    }

    // Handle Mongoose validation errors

    if (err.errors) {
        Object.values(err.errors).forEach((error) => {
            errors[error.properties.path] = error.properties.message;
        });
    }
    errors[err.name] = err.message;

    return errors;
}


module.exports = {
    handleErrors
}