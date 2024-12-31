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
  String _patientName = '';
  bool _isLoading = true;

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
        final paciente = '${historial.data['nombres']} ${historial.data['apellidos']}';
        setState(() {
          _historial = {
            for (var presion in presiones)
              '${presion['fecha']} ${presion['hora']}':
                  '${presion['sistolica']}/${presion['diastolica']}',
          };
          _patientName = paciente;
        });
      }
    } catch (e) {
      ErrorToast.show('No se pudo obtener el historial.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _listPatients() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchHistory(widget.patientId);
  }

  Widget _buildListView() {
    return ListView(
      children: [
        if (_patientName.isNotEmpty)
          Center(
            child: Text(
              _patientName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        const SizedBox(height: 16),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_historial.isEmpty)
          const Center(child: Text('No existen registros.'))
        else
          Center(child: PressureHistoryTable(history: _historial)),
      ],
    );
  }

  Widget _buildGridView() {
    return GridView.count(
      crossAxisCount: 2,
      children: [
        if (_patientName.isNotEmpty)
          Center(
            child: Text(
              _patientName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        const SizedBox(height: 16),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_historial.isEmpty)
          const Center(child: Text('No existen registros.'))
        else
          Center(child: PressureHistoryTable(history: _historial)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial del paciente'),
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
}
