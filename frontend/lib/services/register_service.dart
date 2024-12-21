import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:frontend/controls/backendService/facade_services.dart';
import 'package:frontend/services/login_service.dart';
import 'package:frontend/widgets/toast/error.dart';
import 'package:frontend/widgets/toast/informative.dart';

class RegisterService {
  /// Registra un usuario con los datos proporcionados.
  static Future<void> registerUser({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController correoControl,
    required TextEditingController claveControl,
    required TextEditingController nombreControl,
    required TextEditingController apellidoControl,
    required TextEditingController fechaNacControl,
    required Function(bool) setLoading,
  }) async {
    if (formKey.currentState!.validate()) {
      setLoading(true);

      FacadeServices servicio = FacadeServices();
      Map<String, String> mapa = {
        "correo": correoControl.text,
        "clave": claveControl.text,
        "nombres": nombreControl.text,
        "apellidos": apellidoControl.text,
        "fecha_nacimiento": fechaNacControl.text,
      };
      log(mapa.toString());

      try {
        final value = await servicio.register(mapa);

        if (value.code == 200) {
          InformativeToast.show("Cuenta creada correctamente");
          await LoginService.login(
            context: context,
            formKey: formKey,
            correoControl: correoControl,
            claveControl: claveControl,
            setLoading: setLoading,
          );
        } else {
          final SnackBar msg = SnackBar(content: Text("Error: ${value.msg}"));
          ScaffoldMessenger.of(context).showSnackBar(msg);
        }
      } catch (error) {
        ErrorToast.show("Error durante la creación de la cuenta: $error");
      } finally {
        setLoading(false);
      }
    } else {
      log("Errores en el formulario");
    }
  }
}
