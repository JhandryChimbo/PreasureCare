"use strict";

module.exports = (sequelize, DataTypes) => {
    const persona = sequelize.define(
        "persona",
        {
            nombres: {type: DataTypes.STRING(50), defaultValue: "N/A"},
            apellidos: {type: DataTypes.STRING(50), defaultValue: "N/A"},
            fecha_nacimiento: DataTypes.DATEONLY,
            external_id: {type: DataTypes.UUID, defaultValue: DataTypes.UUIDV4},
        },
        { freezeTableName: true }
    );
    persona.associate = function (models){
        persona.hasOne(models.cuenta, { foreignKey: "id_persona", as: "cuenta"});
        persona.belongsTo(models.rol, { foreignKey: "id_rol" });
        persona.hasMany(models.presion, { foreignKey: "id_persona", as: "presion"});
    };

    return persona;
};