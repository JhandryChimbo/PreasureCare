"use strict";
var models = require("../models");
var presion = models.presion;
var persona = models.persona;
var medicacion = models.medicacion;

class presionControl {
  /**
   * Listar TODAS las presiones con información de la persona asociada.
   * 
   * @param {Object} req - Objeto de solicitud HTTP.
   * @param {Object} res - Objeto de respuesta HTTP.
   * @returns {Promise<void>} - Devuelve una promesa que resuelve con una respuesta HTTP.
   * @throws {Error} - Devuelve un error si ocurre un problema al listar las presiones.
   */
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

  /**
   * Crea un nuevo registro de presión arterial y asigna la medicación correspondiente.
   * 
   * @param {Object} req - Objeto de solicitud HTTP.
   * @param {Object} req.body - Cuerpo de la solicitud que contiene los datos de la presión arterial.
   * @param {string} req.body.fecha - Fecha de la medición.
   * @param {string} req.body.hora - Hora de la medición.
   * @param {number} req.body.sistolica - Valor de la presión sistólica.
   * @param {number} req.body.diastolica - Valor de la presión diastólica.
   * @param {string} req.body.id_persona - ID externo de la persona.
   * @param {Object} res - Objeto de respuesta HTTP.
   * 
   * @returns {Promise<void>} - Devuelve una promesa que resuelve en una respuesta HTTP.
   * 
   * @throws {Error} - Lanza un error si ocurre un problema durante la creación del registro de presión arterial.
   */
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

      const data = {
        fecha,
        hora,
        sistolica,
        diastolica,
        id_persona: existePersona.id,
        external_id: require("uuid").v4(),
      };

      const resultado = await presion.create(data, { transaction });
      if (!resultado) {
        await transaction.rollback();
        return res.status(400).json({ msg: "Error al registrar la presion", code: 400 });
      }

      const medicacionAsignada = await this.asignarMedicacion.bind(this)(sistolica, diastolica, transaction);
      if (!medicacionAsignada) {
        await transaction.rollback();
        return res.status(404).json({
          msg: "No se encontró medicación adecuada",
          code: 404,
        });
      }

      data.medicacion_id = medicacionAsignada.id;
      await resultado.update({ medicacion_id: medicacionAsignada.id }, { transaction });

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

  asignarMedicacion = async (sistolica, diastolica, transaction) => {
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
  
    return medicacionAsignada;
  };  
}

module.exports = presionControl;
