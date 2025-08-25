function handleErrors(err) {
    const errors = {};

    if (err.code === 11000 && err.keyPattern) {
        const field = Object.keys(err.keyPattern)[0];
        const prettyField = field.charAt(0).toUpperCase() + field.slice(1);
        errors[field] = `${prettyField} is already being used.`;
        return errors;
    }

    if (err.name === 'ValidationError' && err.errors) {
        Object.values(err.errors).forEach((mongooseErrorItem) => {
            if (mongooseErrorItem.properties && mongooseErrorItem.properties.path && mongooseErrorItem.properties.message) {
                errors[mongooseErrorItem.properties.path] = mongooseErrorItem.properties.message;
            }
            else if (mongooseErrorItem.path && mongooseErrorItem.message) {
                errors[mongooseErrorItem.path] = mongooseErrorItem.message;
            }
            else if (mongooseErrorItem.message) {
                errors[mongooseErrorItem.name || 'validationError'] = mongooseErrorItem.message;
            }
        });
        if (Object.keys(errors).length > 0) {
            return errors;
        }
    }

    if (Object.keys(errors).length === 0 && err.message) {
        errors[err.name || 'error'] = err.message;
    } else if (Object.keys(errors).length === 0) {
        errors['unknown'] = 'An unexpected error occurred.';
    }

    return errors;
}

module.exports = {
    handleErrors
};