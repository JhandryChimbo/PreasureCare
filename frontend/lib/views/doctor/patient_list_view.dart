import 'package:flutter/material.dart';
import 'package:frontend/services/patient_service.dart';

class PatientListView extends StatelessWidget {
  const PatientListView({super.key});

  @override
  Widget build(BuildContext context) {
    PatientService.listPatients();
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Pacientes')),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return const ListTile(
            title: Text("Paciente xd"),

          );
        },
      ),
    );
  }
}

