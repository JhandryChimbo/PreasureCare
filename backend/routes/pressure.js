var express = require('express');
var router = express.Router();

const auth = require('../middleware/auth');

const cuentaC = require("../app/controls/cuentaControl");
let cuentaControl = new cuentaC();
const inicioSesionValidation = require('../validators/cuentaValidator');

const rolC = require("../app/controls/rolControl");
let rolControl = new rolC();

const personaC = require("../app/controls/personaControl");
const usuarioValidator = require('../validators/usuarioValidator');
let personaControl = new personaC();

const presionC = require("../app/controls/presionControl");
const presionValidator = require('../validators/presionValidator');
let presionControl = new presionC();

const medicacionC = require("../app/controls/medicacionControl");
const medicacionValidator = require('../validators/medicacionValidator');
let medicacionControl = new medicacionC();

/* GET users listing. */
router.get('/', function (req, res, next) {
  res.send('respond with a resource');
});

//LOGIN
router.post("/login", inicioSesionValidation.inicioSesion, cuentaControl.login);

//ROL
router.get("/admin/rol", rolControl.listar);
router.post("/admin/rol/save", rolControl.crear);

//PERSONA
router.get("/admin/persona", auth.authControl, personaControl.listar);
router.get("/admin/persona/:external", auth.authAdministrador, personaControl.listarPorId);
router.post("/admin/persona/save", usuarioValidator.crearUsuario ,auth.authAdministrador, personaControl.crear);
router.post("/persona/save", usuarioValidator.crearUsuario, personaControl.crearUsuario);
router.put("/admin/persona/update/:external", auth.authAdministrador, personaControl.actualizar);
router.put("/admin/persona/estado/:external", auth.authAdministrador, personaControl.actualizarEstado);


//PRESION
router.get("/persona/presiones/:external", auth.authGeneral, personaControl.listarPresiones);
router.get("/persona/presiones/ultima/:external", auth.authGeneral, personaControl.listarUltimaPresion);
router.get("/persona/historial", auth.authGeneral, personaControl.listarHistoriales);
router.get("/presion", auth.authAdministrador, presionControl.listar);
router.post("/presion/save", auth.authGeneral, presionValidator.crear, presionControl.crear);

//MEDICACION
router.get("/medicacion", auth.authControl, medicacionControl.listar);
router.post("/medicacion/save", auth.authControl, medicacionControl.crear);
router.put("/medicacion/update/:external", auth.authControl, medicacionControl.actualizar);

module.exports = router;
