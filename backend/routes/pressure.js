var express = require('express');
var router = express.Router();

let jwt = require("jsonwebtoken");

const rolC = require("../app/controls/rolControl");
let rolControl = new rolC();

const personaC = require("../app/controls/personaControl");
let personaControl = new personaC();

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send('respond with a resource');
});

//ROL
router.get("/admin/rol", rolControl.listar);
router.post("/admin/rol/save", rolControl.crear);

//PERSONA
router.get("/admin/persona", personaControl.listar);
router.get("/admin/persona/:external", personaControl.listarPorId);
router.post("/admin/persona/save", personaControl.crear);
router.put("/admin/persona/update/:external", personaControl.actualizar);

module.exports = router;
