import 'package:flutter/material.dart';

class PressureHistoryTable extends StatelessWidget {
  final Map<String, dynamic> history;

  const PressureHistoryTable({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Historial de Registros',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Presión', style: TextStyle(color: Colors.grey[800]))),
              DataColumn(label: Text('Fecha y Hora', style: TextStyle(color: Colors.grey[800]))),
            ],
            rows: history.entries.map((entry) {
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
}