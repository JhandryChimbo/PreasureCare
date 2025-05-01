"use strict";
module.exports = (sequelize, DataTypes) => {
  const tratamiento = sequelize.define(
    "tratamiento",
    {
      nombre: { type: DataTypes.STRING(50), allowNull: false },
      medicamento: { type: DataTypes.STRING(50), allowNull: false },
      dosis: { type: DataTypes.STRING(50), allowNull: false },
      recomendacion: { type: DataTypes.TEXT, allowNull: false },
      external_id: { type: DataTypes.UUID, defaultValue: DataTypes.UUIDV4 },
    },
    { freezeTableName: true }
  );
  tratamiento.associate = function (models) {
    tratamiento.hasMany(models.presion, { foreignKey: "id_tratamiento", as: "presion" });
  };

  return tratamiento;
};
