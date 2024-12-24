import 'dart:developer';
import 'package:frontend/controls/backendService/facade_services.dart';
import 'package:frontend/controls/backendService/generic_answer.dart';
import 'package:frontend/widgets/toast/error.dart';

class PatientService {
  static Future<void> listPatients() async {
    try {
      final facadeServices = FacadeServices();
      final GenericAnswer listado = await facadeServices.listarPacientes();

      if (listado.data is List) {
        final patients = listado.data as List<dynamic>;

        // Imprimir cada paciente de manera ordenada
        for (var patient in patients) {
          '${patient['nombre']} ${patient['apellido']}';
        }
      } else {
        ErrorToast.show("No se encontró información de pacientes.");
        log("Listado vacío o no es una lista.");
      }
    } catch (error) {
      ErrorToast.show("Error al listar pacientes: $error");
      log("Error: $error");
    }
  }
}
