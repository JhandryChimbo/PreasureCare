"use strict";

module.exports = (sequelize, DataTypes) => {
  const persona = sequelize.define(
    "persona",
    {
      nombres: { type: DataTypes.STRING(50), defaultValue: "N/A" },
      apellidos: { type: DataTypes.STRING(50), defaultValue: "N/A" },
      sexo: {
        type: DataTypes.ENUM("male", "female"),
        allowNull: false,
        defaultValue: "male",
      },
      fecha_nacimiento: DataTypes.DATEONLY,
      riesgo_cardiovascular: {
        type: DataTypes.ENUM(
          "hipertensión arterial",
          "Tabaquismo",
          "extabaquista",
          "dislipidemia"
        ),
        defaultValue: "N/A",
      },
      antecedentes_cardiovasculares: {
        type: DataTypes.ENUM(
          "infarto agudo del miocardio",
          "arritmia",
          "miocardiopatía no dilatada",
          "miocardiopatía dilatada",
          "otros"
        ),
        defaultValue: "otros",
      },
      external_id: { type: DataTypes.UUID, defaultValue: DataTypes.UUIDV4 },
    },
    { freezeTableName: true }
  );
  persona.associate = function (models) {
    persona.hasOne(models.cuenta, { foreignKey: "id_persona", as: "cuenta" });
    persona.belongsTo(models.rol, { foreignKey: "id_rol" });
    persona.hasMany(models.presion, {
      foreignKey: "id_persona",
      as: "presion",
    });
  };

  return persona;
};
