import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:PressureCare/services/register_service.dart';
import 'package:PressureCare/widgets/buttons/button.dart';
import 'package:validators/validators.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  // Clave global para el Stepper
  final _formKey = GlobalKey<FormState>();

  // Claves para cada paso del formulario
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();
  final _formKeyStep3 = GlobalKey<FormState>();
  final _formKeyStep4 = GlobalKey<FormState>();


  // Controladores
  final TextEditingController nombreControl = TextEditingController();
  final TextEditingController apellidoControl = TextEditingController();
  final TextEditingController fechaNacControl = TextEditingController();
  final TextEditingController correoControl = TextEditingController();
  final TextEditingController claveControl = TextEditingController();
  final TextEditingController alturaControl = TextEditingController();
  final TextEditingController pesoControl = TextEditingController();
  final otrosControl = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;
  String? sexo;
  String tabaquismo = 'no';
  bool hipertension = false;
  bool dislipidemia = false;
  bool infarto = false;
  bool arritmia = false;
  bool miocardiopatiaDil = false;
  bool miocardiopatiaNoDil = false;

  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PressureCare",
          style: TextStyle(color: Color(0xFF1E88E5), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1E88E5)),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              _buildBackground(),
              _buildForm(constraints),  
              _buildLoginLink(),            
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
    return Form(
      key: _formKey,
      child: Theme(
        data: ThemeData(
          hintColor: const Color(0xFF1E88E5),
          colorScheme: const ColorScheme.light(primary: Color(0xFF1E88E5)),
        ),
        child: Stepper(
          physics: const ClampingScrollPhysics(),
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: () {
            // Lógica para avanzar al siguiente paso
            bool isLastStep = _currentStep == getSteps().length - 1;

            // Validar el paso actual antes de continuar
            bool isValid = false;
            if (_currentStep == 0) isValid = _formKeyStep1.currentState!.validate();
            if (_currentStep == 1) isValid = _formKeyStep2.currentState!.validate();
            if (_currentStep == 2) isValid = _formKeyStep3.currentState!.validate();
            if (_currentStep == 3) isValid = _formKeyStep4.currentState!.validate();

            if (isValid) {
              if (isLastStep) {
                // Lógica de registro en el último paso
                _registerUser();
              } else {
                setState(() => _currentStep += 1);
              }
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep -= 1);
            }
          },
          onStepTapped: (step) => setState(() => _currentStep = step),
          steps: getSteps(),
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            final isLastStep = _currentStep == getSteps().length - 1;
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  if (_currentStep > 0)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: details.onStepCancel,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xFF1E88E5),
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Atrás'),
                      ),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ConfirmButton(
                      text: isLastStep ? 'Registrar' : 'Siguiente',
                      onPressed: () async {
                        if (details.onStepContinue != null) {
                          details.onStepContinue!();
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Step> getSteps() => [
        Step(
          title: const Text('Información Personal'),
          isActive: _currentStep >= 0,
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          content: Form(
            key: _formKeyStep1,
            child: Column(
              children: [
                _buildNameField(),
                const SizedBox(height: 20),
                _buildLastNameField(),
                const SizedBox(height: 20),
                _buildBirthDateField(),
              ],
            ),
          ),
        ),
        Step(
          title: const Text('Datos Físicos'),
          isActive: _currentStep >= 1,
           state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          content: Form(
            key: _formKeyStep2,
            child: Column(
              children: [
                _buildHeightField(),
                const SizedBox(height: 20),
                _buildWeightField(),
                const SizedBox(height: 20),
                _buildSexField(),
              ],
            ),
          ),
        ),
        Step(
          title: const Text('Antecedentes Médicos'),
          isActive: _currentStep >= 2,
           state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          content: Form(
            key: _formKeyStep3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSmokingField(),
                const SizedBox(height: 20),
                const Text("Marque las condiciones que apliquen:", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E88E5))),
                _buildMedicalHistoryFields(),
                const SizedBox(height: 20),
                _buildOtherMedicalHistoryField(),
              ],
            ),
          ),
        ),
        Step(
          title: const Text('Credenciales de la Cuenta'),
          isActive: _currentStep >= 3,
           state: _currentStep > 3 ? StepState.complete : StepState.indexed,
          content: Form(
            key: _formKeyStep4,
            child: Column(
              children: [
                _buildEmailField(),
                const SizedBox(height: 20),
                _buildPasswordField(),
              ],
            ),
          ),
        ),
      ];
      
  Future<void> _registerUser() async {
    // Validar el formulario completo antes de registrar
     if (!_formKey.currentState!.validate()) return;

    await RegisterService.registerUser(
      context: context,
      formKey: _formKey,
      correoControl: correoControl,
      claveControl: claveControl,
      nombreControl: nombreControl,
      apellidoControl: apellidoControl,
      fechaNacControl: fechaNacControl,
      alturaControl: alturaControl,
      pesoControl: pesoControl,
      sexoControl: TextEditingController(text: sexo ?? ''),
      tabaquismoControl: TextEditingController(text: tabaquismo),
      otrosAntecedentesControl: otrosControl,
      hipertension: hipertension,
      dislipidemia: dislipidemia,
      infartoAgudoMiocardio: infarto,
      arritmia: arritmia,
      miocardiopatiaDilatada: miocardiopatiaDil,
      miocardiopatiaNoDilatada: miocardiopatiaNoDil,
      setLoading: (value) {
        setState(() {});
      },
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: nombreControl,
      validator: (value) {
        if (value == null || value.isEmpty) {
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

  Widget _buildLastNameField() {
    return TextFormField(
      controller: apellidoControl,
      validator: (value) {
        if (value == null || value.isEmpty) {
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
      validator: (value) {
        if (value == null || value.isEmpty) {
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
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFF1E88E5),
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          setState(() {
            fechaNacControl.text = picked.toLocal().toString().split(' ')[0];
          });
        }
      },
    );
  }

  Widget _buildHeightField() {
    return TextFormField(
      controller: alturaControl,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Debe ingresar una altura";
        }
        if (double.tryParse(value) == null) {
          return "Altura inválida";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Altura (cm)",
        prefixIcon: Icon(Icons.height, color: Color(0xFF1E88E5)),
        labelStyle: TextStyle(color: Color(0xFF1E88E5)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF1E88E5)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF1E88E5)),
        ),
      ),
      style: const TextStyle(color: Colors.blue),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }

  Widget _buildWeightField() {
    return TextFormField(
      controller: pesoControl,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Debe ingresar un peso";
        }
         if (double.tryParse(value) == null) {
          return "Peso inválido";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Peso (kg)",
        prefixIcon: Icon(Icons.monitor_weight, color: Color(0xFF1E88E5)),
        labelStyle: TextStyle(color: Color(0xFF1E88E5)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF1E88E5)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF1E88E5)),
        ),
      ),
      style: const TextStyle(color: Colors.blue),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }

  Widget _buildSexField() {
    return DropdownButtonFormField<String>(
      value: sexo,
       validator: (value) => value == null ? 'Seleccione un sexo' : null,
      items: const [
        DropdownMenuItem(value: 'masculino', child: Text('Masculino')),
        DropdownMenuItem(value: 'femenino', child: Text('Femenino')),
      ],
      onChanged: (value) {
        setState(() {
          sexo = value;
        });
      },
      decoration: const InputDecoration(
        labelText: "Sexo",
        prefixIcon: Icon(CupertinoIcons.person_2, color: Color(0xFF1E88E5)),
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

  Widget _buildSmokingField() {
    return DropdownButtonFormField<String>(
      value: tabaquismo,
       validator: (value) => value == null ? 'Seleccione una opción' : null,
      items: const [
        DropdownMenuItem(value: 'activo', child: Text('Activo')),
        DropdownMenuItem(value: 'no', child: Text('No fumador')),
        DropdownMenuItem(value: 'exfumador', child: Text('Exfumador')),
      ],
      onChanged: (value) {
        setState(() {
          tabaquismo = value!;
        });
      },
      decoration: const InputDecoration(
        labelText: "Tabaquismo",
        prefixIcon: Icon(CupertinoIcons.smoke, color: Color(0xFF1E88E5)),
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

  Widget _buildMedicalHistoryCheckbox(String title, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(title, style: const TextStyle(color: Colors.blue),),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF1E88E5),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildMedicalHistoryFields() {
    return Column(
      children: [
        _buildMedicalHistoryCheckbox(
          "Hipertensión",
          hipertension,
          (value) => setState(() => hipertension = value!),
        ),
        _buildMedicalHistoryCheckbox(
          "Dislipidemia",
          dislipidemia,
          (value) => setState(() => dislipidemia = value!),
        ),
        _buildMedicalHistoryCheckbox(
          "Infarto Agudo de Miocardio",
          infarto,
          (value) => setState(() => infarto = value!),
        ),
        _buildMedicalHistoryCheckbox(
          "Arritmia",
          arritmia,
          (value) => setState(() => arritmia = value!),
        ),
        _buildMedicalHistoryCheckbox(
          "Miocardiopatía Dilatada",
          miocardiopatiaDil,
          (value) => setState(() => miocardiopatiaDil = value!),
        ),
        _buildMedicalHistoryCheckbox(
          "Miocardiopatía No Dilatada",
          miocardiopatiaNoDil,
          (value) => setState(() => miocardiopatiaNoDil = value!),
        ),
      ],
    );
  }

  Widget _buildOtherMedicalHistoryField() {
    return TextFormField(
      controller: otrosControl,
      decoration: const InputDecoration(
        labelText: "Otros antecedentes (opcional)",
        prefixIcon: Icon(CupertinoIcons.doc_text, color: Color(0xFF1E88E5)),
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
        if (value == null || value.isEmpty) {
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
        if (value == null || value.isEmpty) {
          return "Debe ingresar una clave";
        }
         if (value.length < 6) {
          return "La clave debe tener al menos 6 caracteres";
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
          "¿Ya tienes cuenta?",
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