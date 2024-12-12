"use strict";
const { rol } = require("../models");
const uuid = require("uuid");

class RolControl {

    /**
     * Listar roles.
     * 
     * Este método obtiene una lista de roles desde la base de datos y la devuelve en la respuesta.
     * 
     * @param {Object} req - El objeto de solicitud HTTP.
     * @param {Object} res - El objeto de respuesta HTTP.
     * @returns {Promise<void>} - Una promesa que se resuelve cuando la operación de listado se completa.
     */
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

    
    /**
     * Crea un nuevo rol en el sistema.
     *
     * @param {Object} req - Objeto de solicitud HTTP.
     * @param {Object} req.body - Cuerpo de la solicitud HTTP.
     * @param {string} req.body.nombre - Nombre del rol a crear.
     * @param {Object} res - Objeto de respuesta HTTP.
     * @returns {Promise<void>} - Devuelve una promesa que resuelve en una respuesta HTTP.
     */
    async crear(req, res) {``
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