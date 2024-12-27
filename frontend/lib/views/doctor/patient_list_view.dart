import 'package:flutter/material.dart';
import 'package:frontend/controls/backendService/facade_services.dart';

class PatientListView extends StatefulWidget {
  const PatientListView({super.key});

  @override
  _PatientListViewState createState() => _PatientListViewState();
}

class _PatientListViewState extends State<PatientListView> {
  List<Map<String, dynamic>> patients = [];

  @override
  void initState() {
    super.initState();
    _listarPatients();
  }

  Future<void> _listarPatients() async {
    try {
      FacadeServices services = FacadeServices();
      var response = await services.listarPacientes();

      if (response.code == 200) {
        setState(() {
          patients = List<Map<String, dynamic>>.from(response.data);
        });
      } else {
        print('Error al listar pacientes');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de pacientes'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title:
                        Text('${patient['nombres']} ${patient['apellidos']}'),
                    subtitle: Text('Correo: ${patient['cuenta']['correo']}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
