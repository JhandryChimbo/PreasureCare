const { body } = require('express-validator');
const ValidatorHandler = require('./validationHandler');

const cuentaValidator = {
    inicioSesion: [
        body('correo')
            .notEmpty().withMessage('El correo es obligatorio')
            .isEmail().withMessage('El correo no es válido'),
        body('clave')
            .notEmpty().withMessage('La clave es obligatoria'),
        ValidatorHandler.handle,
    ],
};

module.exports = cuentaValidator;