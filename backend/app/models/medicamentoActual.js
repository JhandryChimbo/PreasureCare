// modelo medicamentoActual.js
"use strict";
module.exports = (sequelize, DataTypes) => {
  const medicamentoActual = sequelize.define(
    "medicamentoActual",
    {
      nombre: { type: DataTypes.STRING(100), allowNull: false },
      dosis: { type: DataTypes.STRING(50), allowNull: true },
      frecuencia: { type: DataTypes.STRING(50), allowNull: true },
      fecha_inicio: { type: DataTypes.DATEONLY, allowNull: true },
      id_persona: { type: DataTypes.INTEGER, allowNull: false }, // Clave foránea
    },
    { freezeTableName: true }
  );

  medicamentoActual.associate = function (models) {
    medicamentoActual.belongsTo(models.persona, { foreignKey: "id_persona", as: "persona",
    });
  };

  return medicamentoActual;
};