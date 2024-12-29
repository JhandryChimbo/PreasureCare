import 'package:flutter/material.dart';
import 'package:frontend/controls/backendService/facade_services.dart';
import 'package:frontend/widgets/home/pressure_history_table.dart';
import 'package:frontend/widgets/toast/error.dart';

class PatientHistoryView extends StatefulWidget {
  final String patientId;

  const PatientHistoryView({super.key, required this.patientId});

  @override
  _PatientHistoryViewState createState() => _PatientHistoryViewState();
}

class _PatientHistoryViewState extends State<PatientHistoryView> {
  Map<String, dynamic> _historial = {};

  @override
  void initState() {
    super.initState();
    _fetchHistory(widget.patientId);
  }

  Future<void> _fetchHistory(String idPersona) async {
    try {
      final facadeServices = FacadeServices();
      final historial = await facadeServices.historialDia(idPersona);

      if (historial.code == 200) {
        final presiones = historial.data['presion'] as List<dynamic>;
        setState(() {
          _historial = {
            for (var presion in presiones)
              '${presion['fecha']} ${presion['hora']}': '${presion['sistolica']}/${presion['diastolica']}',
          };
        });
      }
    } catch (e) {
      ErrorToast.show('No se pudo obtener el historial.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial del paciente'),
      ),
      body: _historial.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : PressureHistoryTable(history: _historial),
    );
  }
}
