import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:PressureCare/controls/backendService/facade_services.dart';
import 'package:PressureCare/controls/util/util.dart';
import 'package:PressureCare/services/navigation_service.dart';
import 'package:PressureCare/widgets/toast/error.dart';
import 'package:PressureCare/widgets/toast/informative.dart';

class LoginService {
  static Future<void> login({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController correoControl,
    required TextEditingController claveControl,
    required Function(bool) setLoading,
  }) async {
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate()) {
      setLoading(true);

      FacadeServices servicio = FacadeServices();
      Map<String, String> mapa = {
        "correo": correoControl.text,
        "clave": claveControl.text,
      };
      log(mapa.toString());

      final value = await servicio.login(mapa);
      setLoading(false);

      if (value.code == 200) {

        Util util = Util();
        await util.saveValue('token', value.data['token']);
        await util.saveValue('usuario', value.data['usuario']);
        await util.saveValue('external', value.data['external']);

        InformativeToast.show("Bienvenido ${value.data['usuario']}");

        NavigationService.navigateBasedOnRole(context, value.data['token']);
      } else {
        ErrorToast.show(value.msg);
      }
    } else {
      log("Errores en el formulario");
    }
  }
}
