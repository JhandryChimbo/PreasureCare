import 'package:flutter/material.dart';

class MedicationDialog {
  static void show(
    BuildContext context, {
    required String name,
    required String medication,
    required String dosage,
    required String recommendation,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Medicamento Recomendado'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Nombre: $name'),
                Text('Medicamento: $medication'),
                Text('Dosis: $dosage'),
                Text('Recomendación: $recommendation'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => {
                Navigator.of(context).pop(),
                FocusScope.of(context).unfocus()
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
