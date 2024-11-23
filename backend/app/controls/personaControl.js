"use strict";
var models = require("../models");
var rol = models.rol;
var persona = models.persona;
var cuenta = models.cuenta;

var bcrypt = require("bcrypt");

class personaControl {
  async listar(req, res) {
    try {
      const data = await persona.findAll({
        include: [
          { model: models.cuenta, as: "cuenta", attributes: ["correo"] },
          { model: models.rol, attributes: ["nombre"] },
        ],
        attributes: [
          "nombres",
          "apellidos",
          "fecha_nacimiento",
          ["external_id", "id"],
        ],
      });
      res.status(200).json({ msg: "Listado de personas", code: 200, data });
    } catch (error) {
      res.status(500).json({ msg: "Error al listar personas", code: 500 });
    }
  }

  async listarPorId(req, res) {
    const { external } = req.params;
    if (!external) {
      return res.status(400).json({ msg: "Faltan datos", code: 400 });
    }
    try {
      const data = await persona.findOne({
        where: { external_id: external },
        include: [
          { model: models.cuenta, as: "cuenta", attributes: ["correo"] },
          { model: models.rol, attributes: ["nombre"] },
        ],
        attributes: [
          "nombres",
          "apellidos",
          "fecha_nacimiento",
          ["external_id", "id"],
        ],
      });
      if (!data) {
        return res.status(404).json({ msg: "Persona no encontrada", code: 404 });
      }
      res.status(200).json({ msg: "Persona encontrada", code: 200, data });
    } catch (error) {
      res.status(500).json({ msg: "Error interno del servidor", code: 500 });
    }
  }

  async listarPresiones(req, res) {
    const { external } = req.params;
    if (!external) {
      return res.status(400).json({ msg: "Faltan datos", code: 400 });
    }
    try {
      const data = await persona.findOne({
        where: { external_id: external },
        include: [
          {
            model: models.presion,
            as: "presion",
            attributes: ["fecha", "hora", "sistolica", "diastolica"],
          },
        ],
        attributes: ["nombres", "apellidos", "fecha_nacimiento"],
      });
      if (!data) {
        return res.status(404).json({ msg: "Persona no encontrada", code: 404 });
      }
      res.status(200).json({ msg: "Persona encontrada", code: 200, data });
    } catch (error) {
      res.status(500).json({ msg: "Error interno del servidor", code: 500});
    }
  };

  async crear(req, res) {
    const { nombres, apellidos, fecha_nacimiento, correo, clave, id_rol } = req.body;
    if (!nombres || !apellidos || !fecha_nacimiento || !correo || !clave || !id_rol) {
      return res.status(400).json({ msg: "Faltan datos", code: 400 });
    }
    try {
      const existeCuenta = await cuenta.findOne({ where: { correo } });
      if (existeCuenta) {
        return res.status(400).json({ msg: "El correo ya está en uso", code: 400 });
      }
      const uuid = require("uuid");
      const rolAux = await rol.findOne({ where: { external_id: id_rol } });
      if (!rolAux) {
        return res.status(404).json({ msg: "Rol no encontrado", code: 404 });
      }
      const data = {
        nombres,
        apellidos,
        fecha_nacimiento,
        id_rol: rolAux.id,
        external_id: uuid.v4(),
        cuenta: {
          correo,
          clave: bcrypt.hashSync(clave, 10),
        },
      };
      const transaction = await models.sequelize.transaction();
      try {
        const resultado = await persona.create(data, {
          include: [{ model: models.cuenta, as: "cuenta" }],
          transaction,
        });
        if (!resultado) {
          await transaction.rollback();
          return res.status(400).json({ msg: "Error al crear la persona", code: 400 });
        }
        await transaction.commit();
        rolAux.external_id = uuid.v4();
        await rolAux.save();
        res.status(200).json({ msg: "Persona creada", code: 200, data });
      } catch (error) {
        await transaction.rollback();
        res.status(500).json({ msg: "Error en la transacción", code: 500 });
      }
    } catch (error) {
      res.status(500).json({ msg: "Error interno del servidor", code: 500 });
    }
  }

  async actualizar(req, res) {
    const { nombres, apellidos, fecha_nacimiento, id_rol } = req.body;
    const { external } = req.params;
    if (!nombres || !apellidos || !fecha_nacimiento || !id_rol || !external) {
      return res.status(400).json({ msg: "Faltan datos", code: 400 });
    }
    try {
      const transaction = await models.sequelize.transaction();
      const personaModificar = await persona.findOne({ where: { external_id: external }, transaction });
      if (!personaModificar) {
        await transaction.rollback();
        return res.status(404).json({ msg: "Persona no encontrada", code: 404 });
      }
      const rolAux = await rol.findOne({ where: { external_id: id_rol }, transaction });
      if (!rolAux) {
        await transaction.rollback();
        return res.status(404).json({ msg: "Rol no encontrado", code: 404 });
      }
      await personaModificar.update(
        {
          nombres,
          apellidos,
          fecha_nacimiento,
          id_rol: rolAux.id,
          external_id: require("uuid").v4(),
        },
        { transaction }
      );
      await transaction.commit();
      rolAux.external_id = require("uuid").v4();
      await rolAux.save();
      res.status(200).json({ msg: "Persona modificada", code: 200 });
    } catch (error) {
      if (transaction) await transaction.rollback();
      res.status(500).json({ msg: "Error interno del servidor", code: 500 });
    }
  }

  async actualizarEstado(req, res) {
    const { external } = req.params;
    if (!external) {
      return res.status(400).json({ msg: "Faltan datos", code: 400 });
    }
    try {
      const transaction = await models.sequelize.transaction();
      const personaModificar = await persona.findOne({ where: { external_id: external }, include: [{model: cuenta, as: "cuenta"}], transaction });
      if (!personaModificar) {
        await transaction.rollback();
        return res.status(404).json({ msg: "Persona no encontrada", code: 404 });
      }
      personaModificar.cuenta.estado = !personaModificar.cuenta.estado;
      personaModificar.external_id = require("uuid").v4();
      await personaModificar.cuenta.save({ transaction });
      await personaModificar.save({ transaction });
      await transaction.commit();
      res.status(200).json({ msg: "Estado modificado", code: 200 });
    } catch (error) {
      if (transaction) await transaction.rollback();
      res.status(500).json({ msg: "Error interno del servidor", code: 500 });
    }
  }
}

module.exports = personaControl;
