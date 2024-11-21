var express = require('express');
var router = express.Router();

let jwt = require("jsonwebtoken")

const cuentaC = require("../app/controls/cuentaControl");
let cuentaControl = new cuentaC();

const rolC = require("../app/controls/rolControl");
let rolControl = new rolC();

const personaC = require("../app/controls/personaControl");
let personaControl = new personaC();

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send('respond with a resource');
});

//LOGIN
router.post("/login", cuentaControl.login);

//ROL
router.get("/admin/rol", rolControl.listar);
router.post("/admin/rol/save", rolControl.crear);

//PERSONA
router.get("/admin/persona", personaControl.listar);
router.get("/admin/persona/:external", personaControl.listarPorId);
router.post("/admin/persona/save", personaControl.crear);
router.put("/admin/persona/update/:external", personaControl.actualizar);
router.put("/admin/persona/estado/:external", personaControl.actualizarEstado);

module.exports = router;
