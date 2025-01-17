import 'package:flutter/material.dart';
import 'package:PressureCare/views/exception/page404.dart';
import 'package:PressureCare/views/patient/presure_register_view.dart';
import 'package:PressureCare/views/login_view.dart';
import 'package:PressureCare/views/register_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2897FF)),
        useMaterial3: true,
      ),
      home: const LoginView(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/home': (context) => const PressureRegisterView(),
      },
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const Page404());
      },
    );
  }
}
