var express = require('express');
var router = express.Router();

const auth = require('../middleware/auth');

const cuentaC = require("../app/controls/cuentaControl");
let cuentaControl = new cuentaC();
const inicioSesionValidation = require('../validators/cuentaValidator');

const rolC = require("../app/controls/rolControl");
let rolControl = new rolC();

const personaC = require("../app/controls/personaControl");
let personaControl = new personaC();

const presionC = require("../app/controls/presionControl");
const presionValidator = require('../validators/presionValidator');
let presionControl = new presionC();

/* GET users listing. */
router.get('/', function (req, res, next) {
  res.send('respond with a resource');
});

//LOGIN
router.post("/login", inicioSesionValidation.inicioSesion, cuentaControl.login);

//ROL
router.get("/admin/rol", auth.authAdministrador, rolControl.listar);
router.post("/admin/rol/save", auth.authAdministrador, rolControl.crear);

//PERSONA
router.get("/admin/persona", auth.authAdministrador, personaControl.listar);
router.get("/admin/persona/:external", auth.authAdministrador, personaControl.listarPorId);
router.post("/admin/persona/save", auth.authAdministrador, personaControl.crear);
router.put("/admin/persona/update/:external", auth.authAdministrador, personaControl.actualizar);
router.put("/admin/persona/estado/:external", auth.authAdministrador, personaControl.actualizarEstado);


//PRESION
router.get("/persona/presiones/:external", auth.authAdministrador, personaControl.listarPresiones);
router.get("/presion", auth.authAdministrador, presionControl.listar);
router.post("/presion/save", auth.authAdministrador, presionValidator.crear, presionControl.crear);

module.exports = router;
