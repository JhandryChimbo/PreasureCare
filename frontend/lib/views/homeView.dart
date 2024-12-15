import 'package:flutter/material.dart';
import 'package:frontend/controls/util/util.dart';
import 'package:frontend/widgets/buttons/button.dart';
import 'package:frontend/widgets/toast/error.dart';
import 'package:frontend/controls/backendService/FacadeServices.dart';
import 'package:intl/intl.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController sistolicaController = TextEditingController();
  final TextEditingController diastolicaController = TextEditingController();

  final Map<String, dynamic> _historial = {};
  String _ultimaPresion = "N/A";

  @override
  void initState() {
    super.initState();
    _fetchUltimaPresion();
    _fetchHistorial();
  }

  Future<void> _fetchUltimaPresion() async {
    try {
      final String? idPersona = await Util().getValue('external');
      final facadeServices = FacadeServices();
      final ultimaPresion = await facadeServices.ultimaPresion(idPersona!);

      if (ultimaPresion.data['presion'] != null) {
        final presion = ultimaPresion.data['presion'] as List<dynamic>;
        if (presion.isNotEmpty) {
          final sistolica = presion[0]['sistolica'] as int;
          final diastolica = presion[0]['diastolica'] as int;
          setState(() {
            _ultimaPresion = 'Ultimo registro: $sistolica/$diastolica';
          });
          return;
        }
      }
      setState(() {
        _ultimaPresion = 'No se encontró información de presión';
      });
    } catch (e) {
      setState(() {
        _ultimaPresion = 'Error al obtener la última presión';
      });
    }
  }

  Future<void> _registrarPresion() async {
    if (!_formKey.currentState!.validate()) return;

    final sistolica = int.tryParse(sistolicaController.text);
    final diastolica = int.tryParse(diastolicaController.text);
    final idPersona = await Util().getValue('external');

    if (sistolica == null || diastolica == null || idPersona == null) {
      ErrorToast.show('Valores inválidos o usuario no identificado.');
      return;
    }

    final now = DateTime.now();
    final fecha = DateFormat('yyyy-MM-dd').format(now);
    final hora = DateFormat('HH:mm:ss').format(now);

    Map<String, dynamic> presion = {
      'fecha': fecha,
      'hora': hora,
      'sistolica': sistolica,
      'diastolica': diastolica,
      'id_persona': idPersona,
    };

    try {
      FacadeServices facadeServices = FacadeServices();
      final respuesta = await facadeServices.registrarPresion(presion);

      if (respuesta.code == 201) {
        final Map<String, dynamic> medicacion = respuesta.data['medicacion'];

        setState(() {
          _ultimaPresion = 'Ultimo registro: $sistolica/$diastolica';
          _fetchHistorial();
        });

        _showDialog(
          'Medicamento Recomendado',
          'Nombre: ${medicacion['nombre']}\n'
              'Medicamento: ${medicacion['medicamento']}\n'
              'Dosis: ${medicacion['dosis']}\n'
              'Recomendación: ${medicacion['recomendacion']}',
        );
      } else {
        ErrorToast.show('No se pudo registrar la presión.');
      }
    } catch (e) {
      ErrorToast.show('Hubo un problema al registrar la presión.');
    }

    sistolicaController.clear();
    diastolicaController.clear();
  }

  Future<void> _fetchHistorial() async {
    final idPersona = await Util().getValue('external');
    final facadeServices = FacadeServices();
    final historial = await facadeServices.historialDia(idPersona!);

    if (historial.code == 200) {
      final presiones = historial.data['presion'] as List<dynamic>;
      final Map<String, dynamic> registros = {};
      for (final presion in presiones) {
        final fecha = presion['fecha'] as String;
        final hora = presion['hora'] as String;
        final sistolica = presion['sistolica'] as int;
        final diastolica = presion['diastolica'] as int;
        registros['$fecha $hora'] = '$sistolica/$diastolica';
      }
      setState(() {
        _historial.clear();
        _historial.addAll(Map.fromEntries(registros.entries
            .map((entry) => MapEntry(entry.key, entry.value))));
      });
    } else {
      ErrorToast.show('No se pudo obtener el historial de presiones.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingreso de Presión Arterial'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildUltimaPresion(),
                  const SizedBox(height: 16),
                  _buildForm(),
                  const SizedBox(height: 16),
                  _buildHistorial(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUltimaPresion() {
    return Text(
      _ultimaPresion,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
            controller: sistolicaController,
            labelText: 'Presión Sistólica',
            hintText: '',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa un valor para la presión sistólica';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: diastolicaController,
            labelText: 'Presión Diastólica',
            hintText: '',
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
            onPressed: _registrarPresion,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  Widget _buildHistorial() {
    _fetchHistorial();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Historial de Registros',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Presión')),
              DataColumn(label: Text('Fecha y Hora')),
            ],
            rows: _historial.entries.map((entry) {
              return DataRow(cells: [
                DataCell(Text(entry.value)),
                DataCell(Text(entry.key)),
              ]);
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showDialog(String title, String medicacion,
      [String recomendacion = '']) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(medicacion),
                if (recomendacion.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      recomendacion,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
