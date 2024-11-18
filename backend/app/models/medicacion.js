"use strict";
module.exports = (sequelize, DataTypes) => {
  const medicacion = sequelize.define(
    "medicacion",
    {
      nombre: { type: DataTypes.STRING(50), allowNull: false },
      medicamento: { type: DataTypes.STRING(50), allowNull: false },
      dosis: { type: DataTypes.STRING(50), allowNull: false },
      recomendacion: { type: DataTypes.TEXT, allowNull: false },
      external_id: { type: DataTypes.UUID, defaultValue: DataTypes.UUIDV4 },
    },
    { freezeTableName: true }
  );
  medicacion.associate = function (models) {
    medicacion.hasMany(models.registro, {
      foreignKey: "id_medicacion",
      as: "registro",
    });
  };

  return medicacion;
};
