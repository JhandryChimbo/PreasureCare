const validationResult = require('express-validator');

class ValidationHandler {

    static handle(req, res, next) {
        const errors = validationResult.validationResult(req);
        if (!errors.isEmpty()) {
            res.status(400)
            return res.json({ msg: errors.array()[0].msg, code: 400 });
        }
        next();
    }
}

module.exports = ValidationHandler;