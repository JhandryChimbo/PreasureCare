"use strict";

var models = require("../models");
var cuenta = models.cuenta;
var persona = models.persona;
var rol = models.rol;
let jwt = require("jsonwebtoken");

var bcrypt = require("bcrypt");

require("dotenv").config();

class cuentaControl {

    async login(req, res) {
        const { correo, clave } = req.body;
        if (!correo || !clave) {
            return res.status(400).json({ msg: "Faltan datos", code: 400 });
        }
        try {
            const cuentaLogin = await cuenta.findOne({
                where: { correo: correo },
                include: [{ model: persona, attributes: ["nombres", "apellidos", "external_id", "id_rol"] }],
            });
            if (!cuentaLogin) {
                return res.status(404).json({ msg: "Cuenta no encontrada", code: 404 });
            }
            if(cuentaLogin.estado === false){
                return res.status(401).json({ msg: "Cuenta deshabilitada", code: 401 });
            }
            if (!bcrypt.compareSync(clave, cuentaLogin.clave)) {
                return res.status(401).json({ msg: "Credenciales incorrectas", code: 401 });
            }
            const key = process.env.KEY_JWT;
            const token_data = { data: cuentaLogin };
            const token = jwt.sign(token_data, key, { expiresIn: "2h" });
            res.status(200).json({ msg: "Login exitoso", code: 200, token: token });
        } catch (error) {
            res.status(500).json({ msg: "Error interno del servidor", code: 500 });
        }
    }
}

module.exports = cuentaControl;