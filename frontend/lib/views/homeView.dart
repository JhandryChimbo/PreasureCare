import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController sistolicaController = TextEditingController();
  final TextEditingController diastolicaController = TextEditingController();

  List<Map<String, String>> _historial = [];
  String _ultimaPresion = 'N/A';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingreso de Presión Arterial'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            hintText: 'Ejemplo: 120',
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
            hintText: 'Ejemplo: 80',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa un valor para la presión diastólica';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildCalcularButton(),
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

  Widget _buildCalcularButton() {
    return ElevatedButton(
      onPressed: _calcularMedicacion,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF2897FF),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: const Text(
        "Calcular Medicación",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildHistorial() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Historial de Registros',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Presión')),
                  DataColumn(label: Text('Fecha y Hora')),
                ],
                rows: _historial.map((registro) {
                  return DataRow(cells: [
                    DataCell(Text(registro['presion']!)),
                    DataCell(Text(registro['fecha']!)),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _calcularMedicacion() {
    final sistolica = int.tryParse(sistolicaController.text);
    final diastolica = int.tryParse(diastolicaController.text);

    if (sistolica == null || diastolica == null) {
      _showDialog('Error', 'Por favor, ingresa valores válidos para la presión arterial.');
      return;
    }

    String medicacion = '';
    String recomendacion = '';

    if (sistolica < 120 && diastolica < 80) {
      medicacion = 'Presión normal. Mantén un estilo de vida saludable.';
      recomendacion = 'No es necesario medicación en este caso.';
    } else if (sistolica >= 120 && sistolica < 130 && diastolica < 80) {
      medicacion = 'Presión elevada. Monitorear regularmente.';
      recomendacion = 'Es recomendable seguir una dieta saludable, evitar el exceso de sal, y hacer ejercicio regularmente. Consulta a tu médico si es necesario.';
    } else if (sistolica >= 130 && sistolica < 140 || diastolica >= 80 && diastolica < 90) {
      medicacion = 'Hipertensión en etapa 1. Considera consultar con un médico.';
      recomendacion = 'Tu médico puede recomendarte cambios en el estilo de vida, y en algunos casos, medicamentos antihipertensivos como inhibidores de la ECA, diuréticos, o bloqueadores de los canales de calcio.';
    } else if (sistolica >= 140 || diastolica >= 90) {
      medicacion = 'Hipertensión en etapa 2. Consulta a un médico para medicación.';
      recomendacion = 'Es probable que necesites medicamentos antihipertensivos. Es importante que consultes a tu médico para recibir el tratamiento adecuado. Podría incluir medicamentos como betabloqueantes, inhibidores de la ECA o diuréticos.';
    } else {
      medicacion = 'Por favor, verifica los valores ingresados.';
      recomendacion = '';
    }

    String fechaHora = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

    setState(() {
      _ultimaPresion = 'Última Presión: $sistolica / $diastolica ($fechaHora)';
      _historial.insert(0, {'presion': '$sistolica / $diastolica', 'fecha': fechaHora});
    });

    sistolicaController.clear();
    diastolicaController.clear();

    _showDialog('Resultado', medicacion, recomendacion);
  }

  void _showDialog(String title, String medicacion, [String recomendacion = '']) {
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
