import 'package:flutter/material.dart';
import 'package:frontend/controls/backendService/facade_services.dart';
import 'package:frontend/views/doctor/patient_pressure_view.dart';

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
    _listPatients();
  }

  Future<void> _listPatients() async {
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return RefreshIndicator(
            onRefresh: _listPatients,
            child: constraints.maxWidth < 600
                ? _buildListView()
                : _buildGridView(),
          );
        },
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: patients.length,
      itemBuilder: (context, index) {
        final patient = patients[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text('${patient['nombres']} ${patient['apellidos']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Correo: ${patient['cuenta']['correo']}'),
                Text('Fecha de nacimiento: ${patient['fecha_nacimiento']}'),
              ],
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PatientHistoryView(patientId: patient['id']),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
      ),
      itemCount: patients.length,
      itemBuilder: (context, index) {
        final patient = patients[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text('${patient['nombres']} ${patient['apellidos']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Correo: ${patient['cuenta']['correo']}'),
                Text('Fecha de nacimiento: ${patient['fecha_nacimiento']}'),
              ],
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PatientHistoryView(patientId: patient['id']),
              ),
            ),
          ),
        );
      },
    );
  }
}
