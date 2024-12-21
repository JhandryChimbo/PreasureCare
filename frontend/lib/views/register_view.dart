import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/services/register_service.dart';
import 'package:frontend/widgets/buttons/button.dart';
import 'package:validators/validators.dart';

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
  final TextEditingController apellidoControl = TextEditingController();
  final TextEditingController fechaNacControl = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

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
        color: Colors.white, // Fondo blanco
      ),
    );
  }

  Widget _buildForm(BoxConstraints constraints) {
    double horizontalPadding = constraints.maxWidth * 0.1;
    if (constraints.maxWidth > 600) {
      horizontalPadding = constraints.maxWidth * 0.2;
    }

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
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
                  const SizedBox(height: 10),
                  const Text(
                    "Regístrate para continuar",
                    style: TextStyle(color: Color(0xFF1E88E5)),
                  ),
                  const SizedBox(height: 20),
                  _buildNameField(),
                  const SizedBox(height: 20),
                  _buildSurnameField(),
                  const SizedBox(height: 20),
                  _buildBirthDateField(),
                  const SizedBox(height: 20),
                  _buildEmailField(),
                  const SizedBox(height: 20),
                  _buildPasswordField(),
                  const SizedBox(height: 20),
                  ConfirmButton(
                      text: "Registrar",
                      onPressed: () async {
                        await RegisterService.registerUser(
                          context: context,
                          formKey: _formKey,
                          correoControl: correoControl,
                          claveControl: claveControl,
                          nombreControl: nombreControl,
                          apellidoControl: apellidoControl,
                          fechaNacControl: fechaNacControl,
                          setLoading: (value) {
                            setState(() {
                              _isLoading = value;
                            });
                          },
                        );
                        return;
                      }),
                  const SizedBox(height: 20),
                  _buildLoginLink(),
                ],
              ),
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
        prefixIcon: Icon(CupertinoIcons.person, color: Color(0xFF1E88E5)),
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

  Widget _buildSurnameField() {
    return TextFormField(
      controller: apellidoControl,
      validator: (value) {
        if (value!.isEmpty) {
          return "Debe ingresar un apellido";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Apellido",
        prefixIcon: Icon(CupertinoIcons.person, color: Color(0xFF1E88E5)),
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

  Widget _buildBirthDateField() {
    return TextFormField(
      controller: fechaNacControl,
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );

        if (pickedDate != null) {
          setState(() {
            fechaNacControl.text = "${pickedDate.toLocal()}".split(' ')[0];
          });
        }
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Debe ingresar una fecha de nacimiento";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Fecha de Nacimiento",
        prefixIcon: Icon(CupertinoIcons.calendar, color: Color(0xFF1E88E5)),
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
