"use stict";
module.exports = (sequelize, DataTypes) => {
    const historial = sequelize.define(
        "historial",
        {
            external_id: {type: DataTypes.UUID, defaultValue: DataTypes.UUIDV4},
        },
        { freezeTableName: true }
    );
    historial.associate = function (models){
        historial.belongsTo(models.persona, { foreignKey: "id_persona" });
        historial.hasMany(models.registro, { foreignKey: "id_historial", as: "registro"});
    };
    return historial;
};