"use strict";
var models = require("../models");
var rol = models.rol;
class rolControl {
    async listar(req, res) {
        const data = await rol.findAll({
            attributes: ["nombre", ["external_id", "id"]],
        });
        res.status(200);
        res.json({ msg: "Listado de roles", code: 200, data: data });
    }

    async crear(req, res) {
        const { nombre } = req.body;
        if (nombre) {
            const uuid = require("uuid");
            const data = await rol.create({
                nombre: nombre,
                external_id: uuid.v4(),
            });
            res.status(200);
            res.json({ msg: "Rol creado", code: 200, data: data });
        } else {
            res.status(400);
            res.json({ msg: "Faltan datos", code: 400 });
        }
    }
};

module.exports = rolControl;