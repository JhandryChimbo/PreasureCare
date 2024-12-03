"use strict";
var models = require("../models");
var presion = models.presion;
var persona = models.persona;
var medicacion = models.medicacion;

class presionControl {
  async listar(req, res) {
    try {
      const data = await presion.findAll({
        include: [{ model: persona, attributes: ["nombres", "apellidos"] }],
        attributes: [
          "fecha",
          "hora",
          "sistolica",
          "diastolica",
          ["external_id", "id"],
        ],
      });
      res.status(200).json({ msg: "Listado de presiones", code: 200, data: data });
    } catch (error) {
      res.status(500).json({
        msg: "Error al listar presiones",
        code: 500,
        error: error.message,
      });
    }
  }

  async crear(req, res) {
    const { fecha, hora, sistolica, diastolica, id_persona } = req.body;
    if (!fecha || !hora || !sistolica || !diastolica || !id_persona) {
      return res.status(400).json({ msg: "Faltan datos", code: 400 });
    }

    let transaction;
    try {
      transaction = await models.sequelize.transaction();

      const existePersona = await persona.findOne({
        where: { external_id: id_persona },
        transaction,
      });
      if (!existePersona) {
        await transaction.rollback();
        return res.status(404).json({ msg: "Persona no encontrada", code: 404 });
      }

      const medicacionRangos = [
        { rango: [180, 120], nombre: "Crisis hipertensiva" },
        { rango: [140, 90], nombre: "Hipertension en etapa 2" },
        { rango: [130, 80], nombre: "Hipertension en etapa 1" },
        { rango: [120, 79], nombre: "Elevada" },
      ];

      let nombreMedicacion = "Normal";
      for (const { rango, nombre } of medicacionRangos) {
        if (sistolica >= rango[0] || diastolica >= rango[1]) {
          nombreMedicacion = nombre;
          break;
        }
      }

      const medicacionAsignada = await medicacion.findOne({
        where: { nombre: nombreMedicacion },
        attributes: ["nombre", "medicamento", "dosis", "recomendacion", ["external_id", "id"]],
        transaction,
      });

      if (!medicacionAsignada) {
        await transaction.rollback();
        return res.status(404).json({
          msg: `No se encontró medicación para el rango ${nombreMedicacion}`,
          code: 404,
        });
      }

      const uuid = require("uuid");
      const data = {
        fecha,
        hora,
        sistolica,
        diastolica,
        id_persona: existePersona.id,
        external_id: uuid.v4(),
        medicacion_id: medicacionAsignada.id,
      };

      const resultado = await presion.create(data, { transaction });
      if (!resultado) {
        await transaction.rollback();
        return res.status(400).json({ msg: "Error al registrar la presion", code: 400 });
      }
      await transaction.commit();

      res.status(201).json({
        msg: "Presion creada y medicación asignada",
        code: 201,
        data: { ...data, medicacion: medicacionAsignada },
      });
    } catch (error) {
      if (transaction) await transaction.rollback();
      res.status(500).json({
        msg: "Error al crear presion",
        code: 500,
        error: error.message,
      });
    }
  }
}

module.exports = presionControl;
