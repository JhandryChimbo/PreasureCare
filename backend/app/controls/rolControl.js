"use strict";
const { rol } = require("../models");
const uuid = require("uuid");

class RolControl {
    async listar(req, res) {
        try {
            const data = await rol.findAll({
                attributes: ["nombre", ["external_id", "id"]],
            });
            res.status(200).json({ msg: "Listado de roles", code: 200, data });
        } catch (error) {
            res.status(500).json({ msg: "Error al listar roles", code: 500, error: error.message });
        }
    }

    async crear(req, res) {
        const { nombre } = req.body;
        if (!nombre) {
            return res.status(400).json({ msg: "Faltan datos", code: 400 });
        }

        try {
            const data = await rol.create({
                nombre,
                external_id: uuid.v4(),
            });
            res.status(200).json({ msg: "Rol creado", code: 200, data });
        } catch (error) {
            res.status(500).json({ msg: "Error al crear rol", code: 500, error: error.message });
        }
    }
}

module.exports = RolControl;