import 'package:flutter/material.dart';
import 'package:PressureCare/controls/backendService/facade_services.dart';
import 'package:PressureCare/views/doctor/patient_pressure_view.dart';

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

  Future<bool> _onWillPop() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            leading: const Icon(
              Icons.person,
              color: Color(0xFF1E88E5),
            ),
            title: Text(
              '${patient['nombres']} ${patient['apellidos']}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E88E5),
              ),
            ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            leading: const Icon(
              Icons.person,
              color: Color(0xFF1E88E5),
            ),
            title: Text(
              '${patient['nombres']} ${patient['apellidos']}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E88E5),
              ),
            ),
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
