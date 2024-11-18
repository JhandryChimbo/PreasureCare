var express = require('express');
var router = express.Router();

let jwt = require("jsonwebtoken");

const rolC = require("../app/controls/rolControl");
let rolControl = new rolC();

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send('respond with a resource');
});

//ROL
router.get("/admin/rol", rolControl.listar);
router.post("/admin/rol/save", rolControl.crear);

module.exports = router;
