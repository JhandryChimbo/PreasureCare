"use strict";
var models = require("../models");
var medicacion = models.medicacion;
var persona = models.persona;
var presion = models.presion;

class medicacionControl {
    async listar(req, res) {
        try {
            const data = await medicacion.findAll({
                attributes: [
                    "nombre",
                    "medicamento",
                    "dosis",
                    "recomendacion",
                    ["external_id", "id"],
                ],
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
            const uuid = require("uuid");
            const data = {
                nombre,
                medicamento,
                dosis,
                recomendacion,
                external_id: uuid.v4(),
            };
            const resultado = await medicacion.create(data);
            if (!resultado) {
                return res.status(400).json({ msg: "Error al crear medicación", code: 400 });
            }
            res.status(201).json({ msg: "Medicación creada", code: 201 });
        } catch (error) {
            res.status(500).json({ msg: "Error al crear medicación", code: 500 });
        }
    }
};

module.exports = medicacionControl;
