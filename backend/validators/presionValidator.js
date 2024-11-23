const {body} = require('express-validator');
const ValidatorHandler = require('./validationHandler');

const presionValidator = {
    crear: [
        body('fecha')
            .notEmpty().withMessage('La fecha es obligatoria')
            .isDate().withMessage('La fecha debe ser una fecha válida'),
        body('hora')
            .notEmpty().withMessage('La hora es obligatoria')
            .isString().withMessage('La hora debe ser un texto'),
        body('sistolica')
            .notEmpty().withMessage('La sistolica es obligatoria')
            .isNumeric().withMessage('La sistolica debe ser un número'),
        body('diastolica')
            .notEmpty().withMessage('La diastolica es obligatoria')
            .isNumeric().withMessage('La diastolica debe ser un número'),
        ValidatorHandler.handle,
    ],
};
module.exports = presionValidator;