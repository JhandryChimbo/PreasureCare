const { body } = require('express-validator');
const ValidatorHandler = require('./validationHandler');

const usuarioValidator = {
    crearUsuario: [
        body('nombres')
            .notEmpty().withMessage('Los nombres son obligatorio')
            .matches(/^[A-Za-z\s]+$/).withMessage('Los nombres solo pueden contener letras')
            .isLength({ min: 2 }).withMessage('Los nombres deben tener al menos 2 caracteres')
            .isLength({ max: 50 }).withMessage('Los nombres deben tener como máximo 50 caracteres'),
        body('apellidos')
            .notEmpty().withMessage('Los apellidos son obligatorio')
            .matches(/^[A-Za-z\s]+$/).withMessage('Los apellidos solo pueden contener letras')
            .isLength({ min: 2 }).withMessage('Los apellidos deben tener al menos 2 caracteres')
            .isLength({ max: 50 }).withMessage('Los apellidos deben tener como máximo 50 caracteres'),
        body('fecha_nacimiento')
            .notEmpty().withMessage('La fecha de nacimiento es obligatoria')
            .isDate().withMessage('La fecha de nacimiento debe ser una fecha válida')
            .custom((value) => {
                const fechaNacimiento = new Date(value);
                const fechaMinima = new Date('1920-01-01');
                const fechaActual = new Date();
                if (fechaNacimiento < fechaMinima || fechaNacimiento > fechaActual) {
                    throw new Error('La fecha de nacimiento debe ser entre 1920 y ' + fechaActual.getFullYear());
                }
                return true;
            }),
        body('correo')
            .notEmpty().withMessage('El correo es obligatorio')
            .isEmail().withMessage('El correo no es válido'),
        body('clave')
            .notEmpty().withMessage('La clave es obligatoria')
            .isLength({ min: 8 }).withMessage('La clave debe tener al menos 8 caracteres'),
        ValidatorHandler.handle,
    ],
};

module.exports = usuarioValidator;