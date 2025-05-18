"use strict";
module.exports = (sequelize, DataTypes) => {
    const presion = sequelize.define(
        "presion",
        {
            fecha: {type: DataTypes.DATEONLY},
            hora: {type: DataTypes.TIME},
            sistolica : {type: DataTypes.INTEGER, allowNull: false},
            diastolica : {type: DataTypes.INTEGER, allowNull: false},
            external_id: {type: DataTypes.UUID, defaultValue: DataTypes.UUIDV4},
        },
        { freezeTableName: true }
    );
    presion.associate = function (models){
        presion.belongsTo(models.persona, { foreignKey: "id_persona" });
        presion.belongsTo(models.tratamiento, { foreignKey: "id_tratamiento" });
    };

    return presion;
    
};