"use strict";
module.exports = (sequelize, DataTypes) => {
    const presion = sequelize.define(
        "presion",
        {
            fecha: {type: DataTypes.DATEONLY},
            hora: {type: DataTypes.TIME},
            sistolica : {type: DataTypes.TINYINT, allowNull: false},
            diastolica : {type: DataTypes.TINYINT, allowNull: false},
            external_id: {type: DataTypes.UUID, defaultValue: DataTypes.UUIDV4},
        },
        { freezeTableName: true }
    );
    presion.associate = function (models){
        presion.belongsTo(models.historial, { foreignKey: "id_historial" });
        presion.belongsTo(models.persona, { foreignKey: "id_persona" });
        presion.belongsTo(models.medicacion, { foreignKey: "id_medicacion" });
    };

    return presion;
    
};