"use strict";
module.exports = (sequelize, DataTypes) => {
    const registro = sequelize.define(
        "registro",
        {
            fecha: {type: DataTypes.DATEONLY},
            hora: {type: DataTypes.TIME},
            sistolica : {type: DataTypes.TINYINT, allowNull: false},
            diastolica : {type: DataTypes.TINYINT, allowNull: false},
            external_id: {type: DataTypes.UUID, defaultValue: DataTypes.UUIDV4},
        },
        { freezeTableName: true }
    );
    registro.associate = function (models){
        registro.belongsTo(models.historial, { foreignKey: "id_historial" });
        registro.belongsTo(models.persona, { foreignKey: "id_persona" });
        registro.belongsTo(models.medicacion, { foreignKey: "id_medicacion" });
    };

    return registro;
    
};