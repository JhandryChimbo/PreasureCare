"use strict";

module.exports = (sequelize, DataTypes) => {
  const antecedente = sequelize.define(
    "antecedenteCardiovascular",
    {
      tipo: {
        type: DataTypes.ENUM(
          "Infarto agudo de miocardio",
          "Arritmia",
          "Miocardiopatía no dilatada",
          "Miocardiopatía dilatada",
          "Otro"
        ),
        allowNull: false,
      },
      descripcion: { type: DataTypes.STRING(200), allowNull: true },
      fecha_diagnostico: { type: DataTypes.DATEONLY, allowNull: true },
    },
    { freezeTableName: true }
  );

  antecedenteCardiovascular.associate = function (models) {
    antecedenteCardiovascular.belongsTo(models.persona, { foreignKey: "persona_id", as: "persona" });
  };

  return antecedente;
};
