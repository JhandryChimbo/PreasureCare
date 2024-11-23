const jwt = require("jsonwebtoken");
const { cuenta, rol, persona } = require("../app/models");
require("dotenv").config();

const auth = (rolesPermitidos) => async (req, res, next) => {
    const token = req.headers["p-token"];
    if (!token) {
        res.status(401);
        return res.json({
            msg: "ERROR",
            tag: "Falta token",
            code: 401,
        });
    }
    try {
        console.log("Token recibido:", token);
        const decoded = jwt.verify(token, process.env.KEY_JWT);
        console.log("Token decodificado:", decoded);
        
        if (!decoded.external) {
            return res.status(400).json({
                msg: "ERROR",
                tag: "El token no contiene el campo 'external'",
                code: 400,
            });
        }
        const user = await cuenta.findOne({
            where: { external_id: decoded.external },
            include: [
                {
                    model: persona,
                    as: "persona",
                    attributes: ["apellidos", "nombres", "id_rol"],
                },
            ],
        });
        if (!user) {
            return res.status(401).json({
                msg: "ERROR",
                tag: "Token no valido",
                code: 401,
            });
        }
        const userRole = await rol.findOne({ where: { id: user.persona.id_rol } });
        if (rolesPermitidos.includes(userRole.nombre)) {
            return next();
        } else {
            return res.status(403).json({
                msg: "ERROR",
                tag: `Acceso no autorizado`,
                code: 403,
            });
        }
    } catch (err) {
        res.status(401);
        return res.json({
            msg: "ERROR",
            tag: "Token no valido o expirado",
            code: 401,
        });
    }
};

const authGeneral = auth(["administrador", "doctor", "paciente"]);
const authControl = auth(["administrador", "doctor"]);
const authAdministrador = auth(["administrador"]);
const authDoctor = auth(["doctor"]);
const authPaciente = auth(["paciente"]);

module.exports = { auth, authGeneral, authControl, authAdministrador, authDoctor, authPaciente };
