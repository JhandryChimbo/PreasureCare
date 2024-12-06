import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:frontend/controls/backendService/FacadeServices.dart';
import 'package:frontend/controls/util/util.dart';
import 'package:validators/validators.dart';
import 'package:frontend/widgets/toast/informative.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController correoControl = TextEditingController();
  final TextEditingController claveControl = TextEditingController();
  final TextEditingController nombreControl = TextEditingController();
  bool _isLoading = false;

  Future<void> _registrar() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      FacadeServices servicio = FacadeServices();
      Map<String, String> mapa = {
        "correo": correoControl.text,
        "clave": claveControl.text,
        "nombre": nombreControl.text
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
        InformativeToast.show("BIENVENIDO ${value.data['usuario']}");
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (Route<dynamic> route) => false,
        );
      } else {
        InformativeToast.show(value.msg);
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
        color: Colors.white, // Fondo blanco
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  "PressureCare",
                  style: TextStyle(
                    color: Color(0xFF1E88E5),
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/fondo.png'),
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Regístrate para continuar",
                  style: TextStyle(color: Color(0xFF1E88E5)),
                ),
                const SizedBox(height: 20),
                _buildNameField(),
                const SizedBox(height: 20),
                _buildEmailField(),
                const SizedBox(height: 20),
                _buildPasswordField(),
                const SizedBox(height: 20),
                _buildRegisterButton(),
                const SizedBox(height: 20),
                _buildLoginLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: nombreControl,
      validator: (value) {
        if (value!.isEmpty) {
          return "Debe ingresar un nombre";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Nombre",
        prefixIcon: Icon(Icons.person, color: Color(0xFF1E88E5)),
        labelStyle: TextStyle(color: Color(0xFF1E88E5)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF1E88E5)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF1E88E5)),
        ),
      ),
      style: const TextStyle(color: Colors.blue),
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
        prefixIcon: Icon(Icons.email, color: Color(0xFF1E88E5)),
        labelStyle: TextStyle(color: Color(0xFF1E88E5)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF1E88E5)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF1E88E5)),
        ),
      ),
      style: const TextStyle(color: Colors.blue),
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
        prefixIcon: Icon(Icons.lock, color: Color(0xFF1E88E5)),
        labelStyle: TextStyle(color: Color(0xFF1E88E5)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF1E88E5)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF1E88E5)),
        ),
      ),
      style: const TextStyle(color: Colors.blue),
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _registrar,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF2897FF),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: const Text(
        "Registrarse",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "¿Ya tienes una cuenta?",
          style: TextStyle(color: Color(0xFF1E88E5)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (Route<dynamic> route) => false,
            );
          },
          child: const Text(
            "Inicia sesión",
            style: TextStyle(
              color: Color(0xFF2897FF),
              fontSize: 16,
              decoration: TextDecoration.underline,
              decorationColor: Color(0xFF2897FF),
            ),
          ),
        ),
      ],
    );
  }
}
