"use strict";
var models = require("../models");
var rol = models.rol;
var persona = models.persona;
var cuenta = models.cuenta;

var bcrypt = require("bcrypt");

class personaControl {
  /**
   * Lista todas las personas con sus respectivas cuentas y roles.
   * 
   * @param {Object} req - Objeto de solicitud HTTP.
   * @param {Object} res - Objeto de respuesta HTTP.
   * @returns {Promise<void>} - Retorna una promesa que resuelve en una respuesta HTTP con el listado de personas.
   * @throws {Error} - Retorna un error 500 si ocurre un problema al listar las personas.
   */
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

  /**
   * Listar persona por ID.
   * 
   * Este método busca una persona en la base de datos utilizando un ID externo proporcionado en los parámetros de la solicitud.
   * Si el ID externo no está presente, devuelve un error 400.
   * Si la persona no se encuentra, devuelve un error 404.
   * Si ocurre un error en el servidor, devuelve un error 500.
   * 
   * @param {Object} req - El objeto de solicitud HTTP.
   * @param {Object} req.params - Los parámetros de la solicitud.
   * @param {string} req.params.external - El ID externo de la persona.
   * @param {Object} res - El objeto de respuesta HTTP.
   * @returns {Promise<void>} - Una promesa que resuelve en una respuesta HTTP.
   */
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

  /**
   * Listar las presiones de una persona.
   *
   * Este método busca una persona por su ID externo y devuelve sus datos personales
   * junto con las presiones registradas.
   *
   * @param {Object} req - Objeto de solicitud HTTP.
   * @param {Object} req.params - Parámetros de la solicitud.
   * @param {string} req.params.external - ID externo de la persona.
   * @param {Object} res - Objeto de respuesta HTTP.
   * @returns {Promise<void>} - Devuelve una respuesta HTTP con el estado y los datos correspondientes.
   */
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


  /**
   * Listar las últimas 10 presiones de una persona.
   *
   * @async
   * @function listar10Presiones
   * @param {Object} req - Objeto de solicitud HTTP.
   * @param {Object} req.params - Parámetros de la solicitud.
   * @param {string} req.params.external - ID externo de la persona.
   * @param {Object} res - Objeto de respuesta HTTP.
   * @returns {Promise<void>} Responde con un JSON que contiene los datos de la persona y sus últimas 10 presiones, o un mensaje de error.
   */
  async listar10Presiones(req, res) {
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
            limit: 20,
            order: [["fecha", "DESC"], ["hora", "DESC"]],
          },
        ],
        attributes: ["nombres", "apellidos", "fecha_nacimiento"],
      });
      if (!data) {
        return res.status(404).json({ msg: "Persona no encontrada", code: 404 });
      }
      res.status(200).json({ msg: "Persona encontrada", code: 200, data });
    } catch (error) {
      res.status(500).json({ msg: "Error interno del servidor", code: 500 });
    }
  }

  /**
   * Listar los historiales de presión arterial de las personas.
   * 
   * Este método obtiene una lista de personas junto con sus historiales de presión arterial,
   * incluyendo la fecha, hora, presión sistólica y diastólica.
   * 
   * Usado para el apartado del rol doctor.
   * 
   * @param {Object} req - El objeto de solicitud HTTP.
   * @param {Object} res - El objeto de respuesta HTTP.
   * @returns {Promise<void>} - Una promesa que resuelve en una respuesta HTTP con el listado de historiales.
   * @throws {Error} - Retorna un error 500 si ocurre un problema al listar los historiales.
   */
  async listarHistoriales(req, res) {
    try {
      const data = await persona.findAll({
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
      res.status(200).json({ msg: "Listado de historiales", code: 200, data });
    }catch (error) {
      res.status(500).json({ msg: "Error al listar historiales", code: 500 });
    }
  };

   /**
   * Listar la última presión registrada de una persona.
   *
   * Este método busca la última presión registrada de una persona en la base de datos
   * utilizando su identificador externo. Si se encuentra la persona, se devuelve la
   * información de la última presión junto con algunos datos personales.
   *
   * @param {Object} req - Objeto de solicitud HTTP.
   * @param {Object} req.params - Parámetros de la solicitud.
   * @param {string} req.params.external - Identificador externo de la persona.
   * @param {Object} res - Objeto de respuesta HTTP.
   * @returns {Promise<void>} - Devuelve una promesa que resuelve en una respuesta HTTP.
   */
  async listarUltimaPresion(req, res) {
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
            attributes: ["sistolica", "diastolica"],
            order: [["fecha", "DESC"], ["hora", "DESC"]],
            limit: 1,
          },
        ],
        attributes: ["nombres", "apellidos"],
      });
      if (!data) {
        return res.status(404).json({ msg: "Persona no encontrada", code: 404 });
      }
      res.status(200).json({ msg: "Última presión registrada", code: 200, data });
    } catch (error) {
      res.status(500).json({ msg: "Error al listar la última presión", code: 500 });
    }
  };
  
  /**
   * Crea una nueva persona en la base de datos.
   * 
   * @param {Object} req - Objeto de solicitud HTTP.
   * @param {Object} req.body - Cuerpo de la solicitud que contiene los datos de la persona.
   * @param {string} req.body.nombres - Nombres de la persona.
   * @param {string} req.body.apellidos - Apellidos de la persona.
   * @param {string} req.body.fecha_nacimiento - Fecha de nacimiento de la persona.
   * @param {string} req.body.correo - Correo electrónico de la persona.
   * @param {string} req.body.clave - Clave de la cuenta de la persona.
   * @param {string} req.body.id_rol - ID del rol asociado a la persona.
   * @param {Object} res - Objeto de respuesta HTTP.
   * 
   * @returns {Promise<void>} - Retorna una respuesta HTTP con el resultado de la operación.
   * 
   * @throws {Error} - Retorna un error si ocurre algún problema durante la creación de la persona.
   */
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

  /**
   * Crea un nuevo usuario en el sistema.
   *
   * @param {Object} req - Objeto de solicitud HTTP.
   * @param {Object} req.body - Cuerpo de la solicitud que contiene los datos del usuario.
   * @param {string} req.body.nombres - Nombres del usuario.
   * @param {string} req.body.apellidos - Apellidos del usuario.
   * @param {string} req.body.fecha_nacimiento - Fecha de nacimiento del usuario.
   * @param {string} req.body.correo - Correo electrónico del usuario.
   * @param {string} req.body.clave - Clave del usuario.
   * @param {Object} res - Objeto de respuesta HTTP.
   * @returns {Promise<void>} - Respuesta HTTP con el resultado de la operación.
   */
  async crearUsuario(req, res) {
    const { nombres, apellidos, fecha_nacimiento, correo, clave } = req.body;
    if (!nombres || !apellidos || !fecha_nacimiento || !correo || !clave) {
      return res.status(400).json({ msg: "Faltan datos", code: 400 });
    }
    try {
      const existeCuenta = await cuenta.findOne({ where: { correo } });
      if (existeCuenta) {
        return res.status(400).json({ msg: "El correo ya está en uso", code: 400 });
      }
      const uuid = require("uuid");
      const rolAux = await rol.findOne({ where: { nombre: "paciente" } });
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

  /**
   * Actualiza la información de una persona en la base de datos.
   *
   * @param {Object} req - Objeto de solicitud HTTP.
   * @param {Object} req.body - Cuerpo de la solicitud.
   * @param {string} req.body.nombres - Nombres de la persona.
   * @param {string} req.body.apellidos - Apellidos de la persona.
   * @param {string} req.body.fecha_nacimiento - Fecha de nacimiento de la persona.
   * @param {string} req.body.id_rol - ID externo del rol asociado a la persona.
   * @param {Object} req.params - Parámetros de la solicitud.
   * @param {string} req.params.external - ID externo de la persona a actualizar.
   * @param {Object} res - Objeto de respuesta HTTP.
   * @returns {Promise<void>} - Respuesta HTTP con el resultado de la operación.
   */
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

  /**
   * Actualiza el estado de una persona y su cuenta asociada.
   *
   * @param {Object} req - Objeto de solicitud HTTP.
   * @param {Object} res - Objeto de respuesta HTTP.
   * @param {Object} req.params - Parámetros de la solicitud.
   * @param {string} req.params.external - ID externo de la persona.
   * @returns {Promise<void>} - Respuesta HTTP con el estado de la operación.
   */
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
