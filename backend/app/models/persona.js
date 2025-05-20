"use strict";

module.exports = (sequelize, DataTypes) => {
  const persona = sequelize.define(
    "persona",
    {
      nombres: { type: DataTypes.STRING(50), defaultValue: "N/A" },
      apellidos: { type: DataTypes.STRING(50), defaultValue: "N/A" },
      fecha_nacimiento: DataTypes.DATEONLY,
      external_id: { type: DataTypes.UUID, defaultValue: DataTypes.UUIDV4 },

      // FACTORES DE RIESGO CARDIOVASCULAR
      hipertension: { type: DataTypes.BOOLEAN, defaultValue: false },
      tabaquismo: {
        type: DataTypes.ENUM("no", "activo", "exfumador"),
        defaultValue: "no",
      },
      dislipidemia: { type: DataTypes.BOOLEAN, defaultValue: false },
      peso: { type: DataTypes.FLOAT, allowNull: true },
      sobrepeso: { type: DataTypes.BOOLEAN, defaultValue: false },
      sexo: {
        type: DataTypes.ENUM("masculino", "femenino", "otro"),
        allowNull: false,
      },

      // ANTECEDENTES CARDIOVASCULARES
      infarto_agudo_miocardio: { type: DataTypes.BOOLEAN, defaultValue: false },
      arritmia: { type: DataTypes.BOOLEAN, defaultValue: false },
      miocardiopatia_dilatada: { type: DataTypes.BOOLEAN, defaultValue: false },
      miocardiopatia_no_dilatada: { type: DataTypes.BOOLEAN, defaultValue: false },
      otros_antecedentes: { type: DataTypes.TEXT, allowNull: true },
    },
    { freezeTableName: true }
  );

  persona.associate = function (models) {
    persona.hasOne(models.cuenta, { foreignKey: "id_persona", as: "cuenta" });
    persona.belongsTo(models.rol, { foreignKey: "id_rol" });
    persona.hasMany(models.presion, { foreignKey: "id_persona", as: "presion" });
  };

  return persona;
};
