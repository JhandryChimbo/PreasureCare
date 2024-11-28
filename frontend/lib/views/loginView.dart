import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:frontend/controls/backendService/FacadeServices.dart';
import 'package:frontend/controls/util/util.dart';
import 'package:validators/validators.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController correoControl = TextEditingController();
  final TextEditingController claveControl = TextEditingController();
  bool _isLoading = false;

  Future<void> _iniciar() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      FacadeServices servicio = FacadeServices();
      Map<String, String> mapa = {
        "correo": correoControl.text,
        "clave": claveControl.text
      };
      log(mapa.toString());

      final value = await servicio.login(mapa);
      setState(() {
        _isLoading = false;
      });

      if (value.code == 200) {
        log(value.data['token']);
        log(value.data['usuario']);
        Util util = Util();
        await util.saveValue('token', value.data['token']);
        await util.saveValue('usuario', value.data['usuario']);
        await util.saveValue('external', value.data['external']);
        final SnackBar msg = SnackBar(content: Text("BIENVENIDO ${value.data['usuario']}"));
        ScaffoldMessenger.of(context).showSnackBar(msg);
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/animes',
          (Route<dynamic> route) => false,
        );
      } else {
        final SnackBar msg = SnackBar(content: Text("Error ${value.msg}"));
        ScaffoldMessenger.of(context).showSnackBar(msg);
      }
    } else {
      log("Errores");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildForm(),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF42A5F5),
            Color(0xFF478DE0),
            Color.fromARGB(255, 124, 158, 206),
            Color.fromARGB(255, 183, 189, 203),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.4),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    "PressureCare",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Inicio de Sesión",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  _buildEmailField(),
                  const SizedBox(height: 20),
                  _buildPasswordField(),
                  const SizedBox(height: 20),
                  _buildLoginButton(),
                  const SizedBox(height: 20),
                  _buildRegisterLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: correoControl,
      validator: (value) {
        if (value!.isEmpty) {
          return "Debe ingresar un correo";
        }
        if (!isEmail(value)) {
          return "Debe ingresar un correo válido";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Correo",
        prefixIcon: Icon(Icons.email, color: Color(0xFFF8F9FE)),
        labelStyle: TextStyle(color: Color(0xFFF8F9FE)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFF8F9FE)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFF8F9FE)),
        ),
      ),
      style: const TextStyle(color: Color(0xFFF8F9FE)),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      obscureText: true,
      controller: claveControl,
      validator: (value) {
        if (value!.isEmpty) {
          return "Debe ingresar una clave";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Clave",
        prefixIcon: Icon(Icons.lock, color: Color(0xFFF8F9FE)),
        labelStyle: TextStyle(color: Color(0xFFF8F9FE)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFF8F9FE)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFF8F9FE)),
        ),
      ),
      style: const TextStyle(color: Color(0xFFF8F9FE)),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _iniciar,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF2897FF),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        "Iniciar Sesión",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "¿No tienes una cuenta?",
          style: TextStyle(color: Colors.white),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/register',
              (Route<dynamic> route) => false,
            );
          },
          child: const Text(
            "Regístrate",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: Colors.blue, 
            ),
          ),
        ),
        
      ],
    );
  }
}
