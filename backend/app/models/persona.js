"use strict";

module.exports = (sequelize, DataTypes) => {
  const persona = sequelize.define(
    "persona",
    {
      nombres: { type: DataTypes.STRING(50), defaultValue: "N/A" },
      apellidos: { type: DataTypes.STRING(50), defaultValue: "N/A" },
      fecha_nacimiento: DataTypes.DATEONLY, 
      sexo: { type: DataTypes.ENUM('M', 'F', 'Otro'), allowNull: true },
      external_id: { type: DataTypes.UUID, defaultValue: DataTypes.UUIDV4 },
      
      // Factores de riesgo
      hipertension: { type: DataTypes.BOOLEAN, defaultValue: false },
      tabaquismo: {type: DataTypes.ENUM('activo', 'ex-fumador', 'nunca'), defaultValue: 'nunca'},
      dislipidemia: { type: DataTypes.BOOLEAN, defaultValue: false },
      sobrepeso: { type: DataTypes.BOOLEAN, defaultValue: false },
      
      //Otras consideraciones
      altura: { type: DataTypes.FLOAT, allowNull: true },
      peso: { type: DataTypes.FLOAT, allowNull: true },
    },
    { freezeTableName: true }
  );
  persona.associate = function (models) {
    persona.hasOne(models.cuenta, { foreignKey: "id_persona", as: "cuenta" });
    persona.belongsTo(models.rol, { foreignKey: "id_rol" });
    persona.hasMany(models.presion, { foreignKey: "id_persona", as: "presion"});

    // Nuevas asociaciones
    persona.hasMany(models.antecedenteCardiovascular, { foreignKey: "id_persona", as: "antecedentes" });
    persona.hasMany(models.medicamentoActual, { foreignKey: "id_persona", as: "medicamentoActual" });
  };

  return persona;
};
