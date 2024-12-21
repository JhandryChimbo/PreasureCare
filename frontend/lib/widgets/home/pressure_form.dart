import 'package:flutter/material.dart';
import 'package:frontend/widgets/buttons/button.dart';

class PressureForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController systolicController;
  final TextEditingController diastolicController;
  final Future<void> Function() onSubmit;

  const PressureForm({
    super.key,
    required this.formKey,
    required this.systolicController,
    required this.diastolicController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          _buildTextField(
            controller: systolicController,
            labelText: 'Presión Sistólica',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa un valor para la presión sistólica';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: diastolicController,
            labelText: 'Presión Diastólica',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa un valor para la presión diastólica';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ConfirmButton(
            text: "Registrar Presión",
            onPressed: onSubmit,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: labelText,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[800]!, width: 0.5),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
      ),
      validator: validator,
    );
  }
}
