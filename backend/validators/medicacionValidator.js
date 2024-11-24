const {body} = require('express-validator');
const ValidatorHandler = require('./validationHandler');
const { crear } = require('./presionValidator');

const medicacionValidator = {
    crear: [
        body('nombre')
            .notEmpty().withMessage('El nombre es obligatorio')
            .isString().withMessage('El nombre debe ser un texto'),
        body('medicamento')
            .notEmpty().withMessage('El medicamento es obligatorio')
            .isString().withMessage('El medicamento debe ser un texto'),
        body('dosis')
            .notEmpty().withMessage('La dosis es obligatoria')
            .isString().withMessage('La dosis debe ser un texto'),
        body('recomendacion')
            .notEmpty().withMessage('La recomendación es obligatoria')
            .isString().withMessage('La recomendación debe ser un texto'),
        ValidatorHandler.handle,
    ],
};

module.exports = medicacionValidator;