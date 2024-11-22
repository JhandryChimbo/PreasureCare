function handleValidatonErrors(errors) {
    const errorMessages = errors.map(error => ({
        field: error.param,
        message: error.msg
    }));

    return {
        status: 'error',
        errors: errorMessages
    };

}

module.exports = handleValidatonErrors;