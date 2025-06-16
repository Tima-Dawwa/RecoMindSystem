function handleErrors(err) {
    const errors = {};
    // It's often helpful to log the incoming error for debugging unexpected structures
    // console.error("Error received in handleErrors:", JSON.stringify(err, null, 2));

    // Handle duplicate key error (MongoDB code 11000)
    if (err.code === 11000 && err.keyPattern) {
        const field = Object.keys(err.keyPattern)[0];
        // Capitalize first letter of the field for a nicer message
        const prettyField = field.charAt(0).toUpperCase() + field.slice(1);
        errors[field] = `${prettyField} is already being used.`;
        return errors; // Return early for duplicate key errors
    }

    // Handle Mongoose ValidationError explicitly
    if (err.name === 'ValidationError' && err.errors) {
        Object.values(err.errors).forEach((mongooseErrorItem) => {
            // Mongoose ValidatorError instances often have error.properties
            if (mongooseErrorItem.properties && mongooseErrorItem.properties.path && mongooseErrorItem.properties.message) {
                errors[mongooseErrorItem.properties.path] = mongooseErrorItem.properties.message;
            }
            // Mongoose CastError instances (and some others) have path and message directly
            else if (mongooseErrorItem.path && mongooseErrorItem.message) {
                errors[mongooseErrorItem.path] = mongooseErrorItem.message;
            }
            // Fallback for any other unexpected structures within err.errors
            else if (mongooseErrorItem.message) {
                errors[mongooseErrorItem.name || 'validationError'] = mongooseErrorItem.message;
            }
        });
        // Only return if errors were actually populated from err.errors
        // Otherwise, let it fall through to the generic handler if err.errors was empty for some reason
        if (Object.keys(errors).length > 0) {
            return errors;
        }
    }

    // Generic fallback for other errors or if ValidationError didn't populate anything
    // This ensures that if the specific handlers above don't catch and return,
    // a general error message is still constructed.
    // Avoid adding a generic error if specific field errors were already captured.
    if (Object.keys(errors).length === 0 && err.message) {
        errors[err.name || 'error'] = err.message;
    } else if (Object.keys(errors).length === 0) {
        // If no message at all, provide a very generic one
        errors['unknown'] = 'An unexpected error occurred.';
    }

    return errors;
}

module.exports = {
    handleErrors
};