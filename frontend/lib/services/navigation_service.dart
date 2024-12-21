import 'package:flutter/material.dart';
import 'package:frontend/views/home_view.dart';
import 'package:frontend/views/doctor/home_doctor_view.dart';
import 'package:frontend/views/exception/page404.dart';
import 'package:frontend/services/auth_service.dart';

class NavigationService {
  static const Map<String, Widget> roleViews = {
    "paciente": HomeView(),
    "doctor": HomeDoctorView(),
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
