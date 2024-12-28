import 'package:flutter/material.dart';
import 'package:frontend/controls/util/util.dart';
import 'package:frontend/widgets/home/last_pressure_card.dart';
import 'package:frontend/widgets/home/medication_dialog.dart';
import 'package:frontend/widgets/home/pressure_form.dart';
import 'package:frontend/widgets/home/pressure_history_table.dart';
import 'package:frontend/widgets/toast/error.dart';
import 'package:frontend/widgets/toast/confirm.dart';
import 'package:frontend/controls/backendService/facade_services.dart';
import 'package:frontend/widgets/toast/informative.dart';
import 'package:intl/intl.dart';

class PressureRegisterView extends StatefulWidget {
  const PressureRegisterView({super.key});

  @override
  _PressureRegisterViewState createState() => _PressureRegisterViewState();
}

class _PressureRegisterViewState extends State<PressureRegisterView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController systolicController = TextEditingController();
  final TextEditingController diastolicController = TextEditingController();
  
  String _ultimaPresion = "----";
  bool _isLoading = false;
  Map<String, dynamic> _historial = {};

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await Future.wait([_fetchLastPressure(), _fetchHistory()]);
  }

  Future<void> _fetchLastPressure() async {
    try {
      final idPersona = await Util().getValue('external');
      if (idPersona == null) throw Exception('ID Persona is null');

      final facadeServices = FacadeServices();
      final ultimaPresion = await facadeServices.ultimaPresion(idPersona);
      if (ultimaPresion.data['presion'] == null || ultimaPresion.data['presion'].isEmpty) {
        InformativeToast.show('No se ha registrado aún una presión');
        return;
      }
      setState(() {
        _ultimaPresion = ultimaPresion.data['presion'] != null
            ? 'Último registro: ${ultimaPresion.data['presion'][0]['sistolica']}/${ultimaPresion.data['presion'][0]['diastolica']}'
            : 'No se ha registrado aún una presión';
      });
    } catch (e) {
      ErrorToast.show('Error al obtener la última presión');
      setState(() => _ultimaPresion = 'Intentelo más tarde');
    }
  }

  Future<void> _fetchHistory() async {
    try {
      final idPersona = await Util().getValue('external');
      if (idPersona == null) throw Exception('Usuario no identificado.');

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

  Future<void> _registerPressure() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final sistolica = int.tryParse(systolicController.text);
    final diastolica = int.tryParse(diastolicController.text);
    final idPersona = await Util().getValue('external');

    if (sistolica == null || diastolica == null || idPersona == null) {
      ErrorToast.show('Valores inválidos o usuario no identificado.');
      return;
    }

    final now = DateTime.now();
    final presion = {
      'fecha': DateFormat('yyyy-MM-dd').format(now),
      'hora': DateFormat('HH:mm:ss').format(now),
      'sistolica': sistolica,
      'diastolica': diastolica,
      'id_persona': idPersona,
    };

    setState(() => _isLoading = true);

    try {
      final facadeServices = FacadeServices();
      final respuesta = await facadeServices.registrarPresion(presion);

      setState(() {
        _isLoading = false;
      });

      if (respuesta.code == 201) {
        final Map<String, dynamic> medicacion = respuesta.data['medicacion'];

        setState(() {
          _ultimaPresion = 'Último registro: $sistolica/$diastolica';
          _fetchHistory();
        });

        MedicationDialog.show(
          context,
          name: medicacion['nombre'],
          medication: medicacion['medicamento'],
          dosage: medicacion['dosis'],
          recommendation: medicacion['recomendacion'],
        );
        ConfirmToast.show('Presión registrada');
      } else {
        ErrorToast.show('No se pudo registrar la presión.');
      }
    } catch (e) {
      ErrorToast.show('Hubo un problema al registrar la presión.');
    } finally {
      setState(() => _isLoading = false);
      systolicController.clear();
      diastolicController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Ingreso de Presión Arterial'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                LastPressureCard(lastPressure: _ultimaPresion),
                const SizedBox(height: 16),
                PressureForm(
                  formKey: _formKey,
                  systolicController: systolicController,
                  diastolicController: diastolicController,
                  onSubmit: _registerPressure,
                ),
                const SizedBox(height: 16),
                PressureHistoryTable(history: _historial),
              ],
            ),
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
