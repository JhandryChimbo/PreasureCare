const {body} = require('express-validator');

const cuentaValidator = {
    inicioSesion: [
        body('correo').isEmail().withMessage('El correo no es válido'),
        body('clave').isLength({min: 8}).withMessage('La clave debe tener al menos 8 caracteres')
    ],

};

module.exports = cuentaValidator;