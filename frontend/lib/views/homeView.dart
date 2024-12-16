import 'package:flutter/material.dart';
import 'package:frontend/controls/util/util.dart';
import 'package:frontend/widgets/buttons/button.dart';
import 'package:frontend/widgets/toast/error.dart';
import 'package:frontend/widgets/toast/confirm.dart';
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
      if (idPersona == null) throw Exception('ID Persona is null');
      
      final facadeServices = FacadeServices();
      final ultimaPresion = await facadeServices.ultimaPresion(idPersona);

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
    FocusScope.of(context).unfocus();
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

    _showLoadingDialog();

    try {
      FacadeServices facadeServices = FacadeServices();
      final respuesta = await facadeServices.registrarPresion(presion);

      Navigator.of(context).pop(); // Close the loading dialog

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
        ConfirmToast.show('Presión registrada');
      } else {
        ErrorToast.show('No se pudo registrar la presión.');
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close the loading dialog
      ErrorToast.show('Hubo un problema al registrar la presión.');
    }

    sistolicaController.clear();
    diastolicaController.clear();
  }

  Future<void> _fetchHistorial() async {
    final idPersona = await Util().getValue('external');
    if (idPersona == null) {
      ErrorToast.show('Usuario no identificado.');
      return;
    }

    final facadeServices = FacadeServices();
    final historial = await facadeServices.historialDia(idPersona);

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
        _historial.addAll(registros);
      });
    } else {
      ErrorToast.show('No se pudo obtener el historial de presiones.');
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Registrando presión...'),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Ingreso de Presión Arterial',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // foregroundColor: Colors.white,
        // backgroundColor: const Color(0xFF1E88E5),
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
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      _ultimaPresion,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500 ),
    ),
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
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: labelText,
        focusedBorder: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey,width: 0.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
      ),
      validator: validator,
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget _buildHistorial() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Historial de Registros',
          style: TextStyle(fontSize: 18,),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Presión', style: TextStyle(color: Colors.grey[800]))),
              DataColumn(label: Text('Fecha y Hora', style: TextStyle(color: Colors.grey[800]))),
            ],
            rows: _historial.entries.map((entry) {
              return DataRow(cells: [
                DataCell(Text(
                  entry.value,
                  style: TextStyle(color: Colors.grey[600]),
                )),
                DataCell(Text(
                  entry.key,
                  style: TextStyle(color: Colors.grey[600]),
                )),
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
                FocusScope.of(context).unfocus();
              },
            ),
          ],
        );
      },
    );
  }
}
