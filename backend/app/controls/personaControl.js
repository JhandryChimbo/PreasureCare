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
      const rolA = await rol.findOne({ where: { external_id: id_rol } });
      if (!rolA) {
        return res.status(404).json({ msg: "Rol no encontrado", code: 404 });
      }
      const data = {
        nombres,
        apellidos,
        fecha_nacimiento,
        id_rol: rolA.id,
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
        rolA.external_id = uuid.v4();
        await rolA.save();
        res.status(200).json({ msg: "Persona creada", code: 200, data });
      } catch (error) {
        await transaction.rollback();
        res.status(500).json({ msg: "Error en la transacción", code: 500 });
      }
    } catch (error) {
      res.status(500).json({ msg: "Error interno del servidor", code: 500 });
    }
  }
}

module.exports = personaControl;
