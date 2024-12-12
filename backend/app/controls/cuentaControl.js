"use strict";

const models = require("../models");
const { cuenta, persona, rol } = models;
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
require("dotenv").config();

class CuentaControl {
    /**
     * Maneja el inicio de sesión del usuario validando las credenciales y generando un token JWT.
     * 
     * @async
     * @function login
     * @param {Object} req - Objeto de solicitud de Express.
     * @param {Object} req.body - El cuerpo de la solicitud.
     * @param {string} req.body.correo - El correo electrónico del usuario.
     * @param {string} req.body.clave - La contraseña del usuario.
     * @param {Object} res - Objeto de respuesta de Express.
     * @returns {Object} Respuesta JSON con el código de estado y el mensaje.
     * 
     * @description
     * Este método valida el correo electrónico y la contraseña del usuario, verifica si la cuenta está activa,
     * y genera un token JWT si las credenciales son correctas. Incluye el rol del usuario y otra información
     * relevante en la carga útil del token. Si ocurre algún error, devuelve un código de estado HTTP apropiado
     * y un mensaje de error.
     */
    async login(req, res) {
        const { correo, clave } = req.body;
        if (!correo || !clave) {
            return res.status(400).json({ msg: "Faltan datos", code: 400 });
        }

        try {
            const cuentaLogin = await cuenta.findOne({
                where: { correo },
                include: [{ model: persona, attributes: ["nombres", "apellidos", "external_id", "id_rol"] }],
            });

            if (!cuentaLogin) {
                return res.status(404).json({ msg: "Cuenta no encontrada", code: 404 });
            }

            if (cuentaLogin.estado === false) {
                return res.status(401).json({ msg: "Cuenta deshabilitada", code: 401 });
            }

            if (!bcrypt.compareSync(clave, cuentaLogin.clave)) {
                return res.status(401).json({ msg: "Credenciales incorrectas", code: 401 });
            }

            const cuentaRol = await rol.findOne({ where: { id: cuentaLogin.persona.id_rol } });
            const key = process.env.KEY_JWT;
            const token_data = { external: cuentaLogin.external_id, rol: cuentaRol.nombre, check: true };
            const token = jwt.sign(token_data, key, { expiresIn: "2h" });

            const data = {
                token,
                usuario: `${cuentaLogin.persona.nombres} ${cuentaLogin.persona.apellidos}`,
                external: cuentaLogin.persona.external_id,
                rol: cuentaRol.nombre,
            };

            res.status(200).json({ msg: "Login exitoso", code: 200, data });
        } catch (error) {
            res.status(500).json({ msg: "Error interno del servidor", code: 500 });
        }
    }
}

module.exports = CuentaControl;
