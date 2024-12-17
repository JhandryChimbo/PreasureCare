import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/controls/backendService/facade_services.dart';
import 'package:frontend/controls/util/util.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/widgets/buttons/button.dart';
import 'package:validators/validators.dart';
import 'package:frontend/widgets/toast/informative.dart';
import 'package:frontend/widgets/toast/error.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController correoControl = TextEditingController();
  final TextEditingController claveControl = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

Future<void> _iniciar() async {
  FocusScope.of(context).unfocus();
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isLoading = true;
    });

    FacadeServices servicio = FacadeServices();
    Map<String, String> mapa = {
      "correo": correoControl.text,
      "clave": claveControl.text,
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

      NavigationService.navigateBasedOnRole(context, value.data['token']);
    } else {
      ErrorToast.show(value.msg);
    }
  } else {
    log("Errores en el formulario");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              _buildBackground(),
              _buildForm(constraints),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
    );
  }

  Widget _buildForm(BoxConstraints constraints) {
    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth * 0.1,
            ),
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
                  height: constraints.maxHeight * 0.25,
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
                  "Inicia sesion para continuar",
                  style: TextStyle(color: Color(0xFF1E88E5)),
                ),
                const SizedBox(height: 20),
                _buildEmailField(),
                const SizedBox(height: 20),
                _buildPasswordField(),
                const SizedBox(height: 20),
                ConfirmButton(text: "Iniciar Sesión", onPressed: _iniciar),
                const SizedBox(height: 20),
                _buildRegisterLink(),
              ],
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
        prefixIcon: Icon(CupertinoIcons.mail, color: Color(0xFF1E88E5)),
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
      obscureText: _obscureText,
      controller: claveControl,
      validator: (value) {
        if (value!.isEmpty) {
          return "Debe ingresar una clave";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Clave",
        prefixIcon: const Icon(CupertinoIcons.lock, color: Color(0xFF1E88E5)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xFF1E88E5),
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
        labelStyle: const TextStyle(color: Color(0xFF1E88E5)),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF1E88E5)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF1E88E5)),
        ),
      ),
      style: const TextStyle(color: Colors.blue),
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "¿No tienes una cuenta?",
          style: TextStyle(color: Color(0xFF1E88E5)),
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
