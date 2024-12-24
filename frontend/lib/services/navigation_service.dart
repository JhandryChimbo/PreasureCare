import 'package:flutter/material.dart';
import 'package:frontend/views/patient/presure_register_view.dart';
import 'package:frontend/views/doctor/patient_list_view.dart';
import 'package:frontend/views/exception/page404.dart';
import 'package:frontend/services/auth_service.dart';

class NavigationService {
  static const Map<String, Widget> roleViews = {
    "paciente": PressureRegisterView(),
    "doctor": PatientListView(),
    "guest": Page404(),
  };

  static void navigateBasedOnRole(BuildContext context, String token) {
    String? role = AuthService.getUserRole(token);

    if (role != null && roleViews.containsKey(role)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => roleViews[role]!),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Page404()),
      );
    }
  }
}
