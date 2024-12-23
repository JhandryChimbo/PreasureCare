import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Clase que representa a un paciente
class Paciente {
  final String id;
  final String nombre;
  final List<RegistroPresion> historial;

  Paciente({required this.id, required this.nombre, required this.historial});
}

// Clase para representar un registro de presión arterial
class RegistroPresion {
  final int sistolica;
  final int diastolica;
  final DateTime fecha;
  final String medicacion;
  final String recomendacion;

  RegistroPresion({
    required this.sistolica,
    required this.diastolica,
    required this.fecha,
    required this.medicacion,
    required this.recomendacion,
  });
}

class HomeDoctorView extends StatelessWidget {
  const HomeDoctorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pacientes = [
      Paciente(
        id: '1',
        nombre: 'Juan Pérez',
        historial: [
          RegistroPresion(
            sistolica: 120,
            diastolica: 80,
            fecha: DateTime.now().subtract(const Duration(days: 1)),
            medicacion: 'No requiere medicación.',
            recomendacion: 'Mantener un estilo de vida saludable.',
          ),
          RegistroPresion(
            sistolica: 125,
            diastolica: 85,
            fecha: DateTime.now().subtract(const Duration(days: 3)),
            medicacion: 'Monitorear la presión.',
            recomendacion: 'Seguir una dieta baja en sal.',
          ),
        ],
      ),
      Paciente(
        id: '2',
        nombre: 'Ana Gómez',
        historial: [
          RegistroPresion(
            sistolica: 135,
            diastolica: 88,
            fecha: DateTime.now().subtract(const Duration(days: 5)),
            medicacion: 'Considerar medicación.',
            recomendacion: 'Consultar con un médico.',
          ),
        ],
      ),
      Paciente(
        id: '3',
        nombre: 'Carlos López',
        historial: [
          RegistroPresion(
            sistolica: 140,
            diastolica: 90,
            fecha: DateTime.now().subtract(const Duration(days: 7)),
            medicacion: 'Requiere medicación.',
            recomendacion: 'Aumentar la actividad física.',
          ),
          RegistroPresion(
            sistolica: 145,
            diastolica: 92,
            fecha: DateTime.now().subtract(const Duration(days: 10)),
            medicacion: 'Requiere medicación.',
            recomendacion: 'Monitorear presión con frecuencia.',
          ),
        ],
      ),
      Paciente(
        id: '4',
        nombre: 'Marta Rodríguez',
        historial: [
          RegistroPresion(
            sistolica: 125,
            diastolica: 80,
            fecha: DateTime.now().subtract(const Duration(days: 12)),
            medicacion: 'No requiere medicación.',
            recomendacion: 'Evitar el estrés.',
          ),
        ],
      ),
      Paciente(
        id: '5',
        nombre: 'Luis Martínez',
        historial: [
          RegistroPresion(
            sistolica: 130,
            diastolica: 85,
            fecha: DateTime.now().subtract(const Duration(days: 3)),
            medicacion: 'Tomar medicación diaria.',
            recomendacion: 'Evitar alimentos procesados.',
          ),
        ],
      ),
      Paciente(
        id: '6',
        nombre: 'Paola Sánchez',
        historial: [
          RegistroPresion(
            sistolica: 115,
            diastolica: 75,
            fecha: DateTime.now().subtract(const Duration(days: 8)),
            medicacion: 'No requiere medicación.',
            recomendacion: 'Mantener una dieta equilibrada.',
          ),
          RegistroPresion(
            sistolica: 120,
            diastolica: 80,
            fecha: DateTime.now().subtract(const Duration(days: 14)),
            medicacion: 'No requiere medicación.',
            recomendacion: 'Monitorear regularmente.',
          ),
        ],
      ),
      Paciente(
        id: '7',
        nombre: 'Ricardo Hernández',
        historial: [
          RegistroPresion(
            sistolica: 140,
            diastolica: 95,
            fecha: DateTime.now().subtract(const Duration(days: 6)),
            medicacion: 'Tomar medicación diaria.',
            recomendacion: 'Consultar con especialista.',
          ),
        ],
      ),
      Paciente(
        id: '8',
        nombre: 'Sofía Díaz',
        historial: [
          RegistroPresion(
            sistolica: 130,
            diastolica: 88,
            fecha: DateTime.now().subtract(const Duration(days: 4)),
            medicacion: 'Monitorear la presión.',
            recomendacion: 'Reducir el consumo de sal.',
          ),
          RegistroPresion(
            sistolica: 138,
            diastolica: 90,
            fecha: DateTime.now().subtract(const Duration(days: 10)),
            medicacion: 'Tomar medicación según lo indicado.',
            recomendacion: 'Realizar ejercicio de manera constante.',
          ),
        ],
      ),
      Paciente(
        id: '9',
        nombre: 'Diego Álvarez',
        historial: [
          RegistroPresion(
            sistolica: 120,
            diastolica: 82,
            fecha: DateTime.now().subtract(const Duration(days: 9)),
            medicacion: 'No requiere medicación.',
            recomendacion: 'Evitar el alcohol y tabaco.',
          ),
        ],
      ),
      Paciente(
        id: '10',
        nombre: 'Gabriela García',
        historial: [
          RegistroPresion(
            sistolica: 125,
            diastolica: 84,
            fecha: DateTime.now().subtract(const Duration(days: 11)),
            medicacion: 'Monitorear la presión.',
            recomendacion: 'Mantener una dieta balanceada.',
          ),
        ],
      ),
      Paciente(
        id: '11',
        nombre: 'Samuel Torres',
        historial: [
          RegistroPresion(
            sistolica: 128,
            diastolica: 85,
            fecha: DateTime.now().subtract(const Duration(days: 15)),
            medicacion: 'Tomar medicación diaria.',
            recomendacion: 'Consultar con un cardiólogo.',
          ),
        ],
      ),
      Paciente(
        id: '12',
        nombre: 'Lucía Ramírez',
        historial: [
          RegistroPresion(
            sistolica: 122,
            diastolica: 78,
            fecha: DateTime.now().subtract(const Duration(days: 4)),
            medicacion: 'No requiere medicación.',
            recomendacion: 'Realizar chequeos periódicos.',
          ),
        ],
      ),
      Paciente(
        id: '13',
        nombre: 'Esteban Morales',
        historial: [
          RegistroPresion(
            sistolica: 130,
            diastolica: 85,
            fecha: DateTime.now().subtract(const Duration(days: 2)),
            medicacion: 'Considerar medicación.',
            recomendacion: 'Monitorear la presión frecuentemente.',
          ),
        ],
      ),
      Paciente(
        id: '14',
        nombre: 'Valentina Castro',
        historial: [
          RegistroPresion(
            sistolica: 118,
            diastolica: 76,
            fecha: DateTime.now().subtract(const Duration(days: 6)),
            medicacion: 'No requiere medicación.',
            recomendacion: 'Mantener actividad física diaria.',
          ),
        ],
      ),
      Paciente(
        id: '15',
        nombre: 'Felipe Pérez',
        historial: [
          RegistroPresion(
            sistolica: 145,
            diastolica: 95,
            fecha: DateTime.now().subtract(const Duration(days: 8)),
            medicacion: 'Tomar medicación según lo indicado.',
            recomendacion: 'Controlar el estrés y ansiedad.',
          ),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Pacientes')),
      body: ListView.builder(
        itemCount: pacientes.length,
        itemBuilder: (context, index) {
          final paciente = pacientes[index];
          return ListTile(
            title: Text(paciente.nombre),
            onTap: () {
              // Navegar a la pantalla de detalles del paciente
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PatientDetailsView(paciente: paciente),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PatientDetailsView extends StatelessWidget {
  final Paciente paciente;

  const PatientDetailsView({Key? key, required this.paciente}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Historial de ${paciente.nombre}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Historial de Presión',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Presión')),
                    DataColumn(label: Text('Fecha')),
                    DataColumn(label: Text('Medicacion')),
                    DataColumn(label: Text('Recomendación')),
                  ],
                  rows: paciente.historial.map((registro) {
                    return DataRow(cells: [
                      DataCell(Text('${registro.sistolica} / ${registro.diastolica}')),
                      DataCell(Text(DateFormat('yyyy-MM-dd HH:mm').format(registro.fecha))),
                      DataCell(Text(registro.medicacion)),
                      DataCell(Text(registro.recomendacion)),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
