import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:PressureCare/controls/backendService/facade_services.dart';
import 'package:PressureCare/services/login_service.dart';
import 'package:PressureCare/widgets/toast/error.dart';
import 'package:PressureCare/widgets/toast/informative.dart';

class RegisterService {
  static Future<void> registerUser({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController correoControl,
    required TextEditingController claveControl,
    required TextEditingController nombreControl,
    required TextEditingController apellidoControl,
    required TextEditingController fechaNacControl,
    required TextEditingController alturaControl,
    required TextEditingController pesoControl,
    required TextEditingController sexoControl,    
    required TextEditingController tabaquismoControl,
    required TextEditingController otrosAntecedentesControl,
    required bool hipertension,
    required bool dislipidemia,
    required bool infartoAgudoMiocardio,
    required bool arritmia,
    required bool miocardiopatiaDilatada,
    required bool miocardiopatiaNoDilatada,
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
        "altura": (int.tryParse(alturaControl.text) ?? 0).toString(),
        "peso": (int.tryParse(pesoControl.text) ?? 0).toString(),
        "sexo": sexoControl.text,
        "tabaquismo": tabaquismoControl.text,
        "otros_antecedentes": otrosAntecedentesControl.text,
        "hipertension": hipertension.toString(),
        "dislipidemia": dislipidemia.toString(),
        "infarto_agudo_miocardio": infartoAgudoMiocardio.toString(),
        "arritmia": arritmia.toString(),
        "miocardiopatia_dilatada": miocardiopatiaDilatada.toString(),
        "miocardiopatia_no_dilatada": miocardiopatiaNoDilatada.toString(),
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
          
            ErrorToast.show("Error: ${value.msg}");
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
