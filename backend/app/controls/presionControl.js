"use strict";
var models = require("../models");
var presion = models.presion;
var persona = models.persona;
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
      res.status(200);
      res.json({ msg: "Listado de presiones", code: 200, data: data });
    } catch (error) {
      res.status(500);
      res.json({
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
    try {
      const existePersona = await persona.findOne({
        where: { external_id: id_persona },
      });
      if (!existePersona) {
        return res
          .status(404)
          .json({ msg: "Persona no encontrada", code: 404 });
      }
      const uuid = require("uuid");
      const data = {
        fecha,
        hora,
        sistolica,
        diastolica,
        id_persona: existePersona.id,
        external_id: uuid.v4(),
      };
      const transaction = await models.sequelize.transaction();
      try {
        const resultado = await presion.create(data, {
          include: [{ model: persona, as: "persona" }],
          transaction,
        });
        if (!resultado) {
          await transaction.rollback();
          return res
            .status(400)
            .json({ msg: "Error al crear presion", code: 400 });
        }
        await transaction.commit();
        res.status(201).json({ msg: "Presion creada", code: 201, data });
      } catch (error) {
        await transaction.rollback();
        res.status(500).json({ msg: "Error en la transacción", code: 500 });
      }
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
