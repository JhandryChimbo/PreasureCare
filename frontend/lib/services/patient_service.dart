import 'package:frontend/controls/backendService/facade_services.dart';
import 'package:frontend/widgets/toast/error.dart';

class PatientService {
  static Future<void> listPatients() async {
    try {
      final facadeServices = FacadeServices();
      final listado = await facadeServices.listarPacientes();
      if (listado.code == 200) {
        final patients = listado.data;
        print(patients);
      } else {
        ErrorToast.show("No se encontró información de pacientes.");
        print("Listado vacío o no es una lista.");
      }
    } catch (error) {
      ErrorToast.show("Error al listar pacientes: $error");
      print(error);
    }
  }
}
