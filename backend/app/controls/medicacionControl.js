"use strict";
const { medicacion, sequelize } = require("../models");
const { v4: uuidv4 } = require("uuid");

class MedicacionControl {
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
