import 'package:flutter/material.dart';
import 'package:frontend/services/patient_service.dart';
import 'package:frontend/widgets/buttons/button.dart';

class PatientListView extends StatelessWidget {
  const PatientListView({super.key});

  @override
  Widget build(BuildContext context) {
    PatientService.listPatients();
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Pacientes')),
      body: Column(
        children: [
          ConfirmButton(text: "Recargar", onPressed: () => PatientService.listPatients()),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return const ListTile(
                  title: Text("Paciente xd"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

