"use strict";
const { medicacion, sequelize } = require("../models");
const { v4: uuidv4 } = require("uuid");

class MedicacionControl {
    /**
     * Listar todas las medicaciones.
     * 
     * Este método obtiene una lista de todas las medicaciones disponibles en la base de datos.
     * 
     * @param {Object} req - Objeto de solicitud HTTP.
     * @param {Object} res - Objeto de respuesta HTTP.
     * @returns {Promise<void>} - Devuelve una promesa que resuelve con una respuesta HTTP.
     */
    async listar(req, res) {
        try {
            const data = await medicacion.findAll({
                attributes: ["nombre", "medicamento", "dosis", "recomendacion", ["external_id", "id"]],
            });
            res.status(200).json({ msg: "Listado de medicaciones", code: 200, data });
        } catch (error) {
            res.status(500).json({ msg: "Error al listar medicaciones", code: 500 });
        }
    }

    /**
     * Crea una nueva medicación.
     * 
     * @param {Object} req - Objeto de solicitud HTTP.
     * @param {Object} req.body - Cuerpo de la solicitud que contiene los datos de la medicación.
     * @param {string} req.body.nombre - Nombre del paciente.
     * @param {string} req.body.medicamento - Nombre del medicamento.
     * @param {string} req.body.dosis - Dosis del medicamento.
     * @param {string} req.body.recomendacion - Recomendaciones adicionales.
     * @param {Object} res - Objeto de respuesta HTTP.
     * 
     * @returns {Promise<void>} Responde con un estado HTTP y un mensaje JSON.
     */
    async crear(req, res) {
        const { nombre, medicamento, dosis, recomendacion } = req.body;
        if (!nombre || !medicamento || !dosis || !recomendacion) {
            return res.status(400).json({ msg: "Faltan datos", code: 400 });
        }
        try {
            const data = { nombre, medicamento, dosis, recomendacion, external_id: uuidv4() };
            const resultado = await medicacion.create(data);
            if (!resultado) {
                return res.status(400).json({ msg: "Error al crear medicación", code: 400 });
            }
            res.status(201).json({ msg: "Medicación creada", code: 201 });
        } catch (error) {
            res.status(500).json({ msg: "Error al crear medicación", code: 500 });
        }
    }

    /**
     * Actualiza la información de una medicación existente.
     *
     * @async
     * @function actualizar
     * @param {Object} req - Objeto de solicitud HTTP.
     * @param {Object} req.params - Parámetros de la solicitud.
     * @param {string} req.params.external - ID externo de la medicación a actualizar.
     * @param {Object} req.body - Cuerpo de la solicitud HTTP.
     * @param {string} req.body.nombre - Nombre de la medicación.
     * @param {string} req.body.medicamento - Tipo de medicamento.
     * @param {string} req.body.dosis - Dosis del medicamento.
     * @param {string} req.body.recomendacion - Recomendaciones adicionales.
     * @param {Object} res - Objeto de respuesta HTTP.
     * @returns {Promise<void>} - Devuelve una promesa que se resuelve cuando la operación ha finalizado.
     * @throws {Error} - Lanza un error si ocurre un problema durante la actualización.
     */
    async actualizar(req, res) {
        const { external } = req.params;
        const { nombre, medicamento, dosis, recomendacion } = req.body;
        if (!nombre || !medicamento || !dosis || !recomendacion) {
            return res.status(400).json({ msg: "Faltan datos", code: 400 });
        }
        let transaction;
        try {
            transaction = await sequelize.transaction();
            const medicacionModificar = await medicacion.findOne({ where: { external_id: external }, transaction });
            if (!medicacionModificar) {
                await transaction.rollback();
                return res.status(404).json({ msg: "Medicación no encontrada", code: 404 });
            }
            await medicacionModificar.update({ nombre, medicamento, dosis, recomendacion }, { transaction });
            await transaction.commit();
            res.status(200).json({ msg: "Medicación actualizada", code: 200 });
        } catch (error) {
            if (transaction) await transaction.rollback();
            res.status(500).json({ msg: "Error al actualizar medicación", code: 500 });
        }
    }
}

module.exports = MedicacionControl;
