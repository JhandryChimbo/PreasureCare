import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:PressureCare/services/register_service.dart';
import 'package:PressureCare/widgets/buttons/button.dart';
import 'package:validators/validators.dart';

abstract class AppColors {
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color accentBlue = Color(0xFF2897FF);
  static const Color textBlue = Colors.blue;
  static const Color white = Colors.white;
  static const Color black = Colors.black;
}

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final List<GlobalKey<FormState>> _stepFormKeys = List.generate(4, (_) => GlobalKey<FormState>());

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otherMedicalHistoryController = TextEditingController();

  bool _isLoading = false;
  bool _obscureText = true;
  String? _selectedSex;
  String _smokingStatus = 'no';
  bool _hasHypertension = false;
  bool _hasDyslipidemia = false;
  bool _hasMyocardialInfarction = false;
  bool _hasArrhythmia = false;
  bool _hasDilatedCardiomyopathy = false;
  bool _hasNonDilatedCardiomyopathy = false;

  int _currentStep = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _birthDateController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _otherMedicalHistoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      // Use resizeToAvoidBottomInset: false to prevent the Scaffold from resizing.
      // We will handle the positioning manually with Stack.
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _buildBackground(),
          // Wrap the Stepper in a SingleChildScrollView
          // This allows the Stepper content to scroll when the keyboard is open
          // without pushing the bottom link up.
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(), // Keeps scrolling natural
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80.0), // Add padding for the login link
              child: _buildForm(),
            ),
          ),
          _buildLoginLink(),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        "PressureCare",
        style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: AppColors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.primaryBlue),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
    );
  }

  // Removed constraints from _buildForm as it's now inside SingleChildScrollView
  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Theme(
        data: ThemeData(
          hintColor: AppColors.primaryBlue,
          colorScheme: const ColorScheme.light(primary: AppColors.primaryBlue),
        ),
        child: Stepper(
          physics: const NeverScrollableScrollPhysics(), // Stepper itself should not scroll; its parent SingleChildScrollView will
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: _onStepContinue,
          onStepCancel: _onStepCancel,
          onStepTapped: (step) => setState(() => _currentStep = step),
          steps: _getSteps(),
          controlsBuilder: _buildStepperControls,
        ),
      ),
    );
  }

  void _onStepContinue() {
    bool isLastStep = _currentStep == _getSteps().length - 1;
    bool isValid = _stepFormKeys[_currentStep].currentState!.validate();

    if (isValid) {
      if (isLastStep) {
        _registerUser();
      } else {
        setState(() => _currentStep += 1);
      }
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }

  Widget _buildStepperControls(BuildContext context, ControlsDetails details) {
    final isLastStep = _currentStep == _getSteps().length - 1;
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
                  foregroundColor: AppColors.primaryBlue,
                  backgroundColor: AppColors.white,
                  side: const BorderSide(color: AppColors.primaryBlue),
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
  }

  List<Step> _getSteps() => [
        Step(
          title: const Text('Información Personal'),
          isActive: _currentStep >= 0,
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          content: Form(
            key: _stepFormKeys[0],
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
            key: _stepFormKeys[1],
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
            key: _stepFormKeys[2],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSmokingField(),
                const SizedBox(height: 20),
                const Text(
                  "Marque las condiciones que apliquen:",
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                ),
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
            key: _stepFormKeys[3],
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
    setState(() => _isLoading = true);
    try {
      await RegisterService.registerUser(
        context: context,
        formKey: _formKey,
        correoControl: _emailController,
        claveControl: _passwordController,
        nombreControl: _nameController,
        apellidoControl: _lastNameController,
        fechaNacControl: _birthDateController,
        alturaControl: _heightController,
        pesoControl: _weightController,
        sexoControl: TextEditingController(text: _selectedSex ?? ''),
        tabaquismoControl: TextEditingController(text: _smokingStatus),
        otrosAntecedentesControl: _otherMedicalHistoryController,
        hipertension: _hasHypertension,
        dislipidemia: _hasDyslipidemia,
        infartoAgudoMiocardio: _hasMyocardialInfarction,
        arritmia: _hasArrhythmia,
        miocardiopatiaDilatada: _hasDilatedCardiomyopathy,
        miocardiopatiaNoDilatada: _hasNonDilatedCardiomyopathy,
        setLoading: (value) {
          setState(() => _isLoading = value);
        },
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  InputDecoration _buildInputDecoration(String labelText, IconData icon) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(icon, color: AppColors.primaryBlue),
      labelStyle: const TextStyle(color: AppColors.primaryBlue),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryBlue),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryBlue),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      validator: (value) => value == null || value.isEmpty ? "Debe ingresar un nombre" : null,
      decoration: _buildInputDecoration("Nombre", CupertinoIcons.person),
      style: const TextStyle(color: AppColors.textBlue),
    );
  }

  Widget _buildLastNameField() {
    return TextFormField(
      controller: _lastNameController,
      validator: (value) => value == null || value.isEmpty ? "Debe ingresar un apellido" : null,
      decoration: _buildInputDecoration("Apellido", CupertinoIcons.person),
      style: const TextStyle(color: AppColors.textBlue),
    );
  }

  Widget _buildBirthDateField() {
    return TextFormField(
      controller: _birthDateController,
      readOnly: true,
      validator: (value) => value == null || value.isEmpty ? "Debe ingresar una fecha de nacimiento" : null,
      decoration: _buildInputDecoration("Fecha de Nacimiento", CupertinoIcons.calendar),
      style: const TextStyle(color: AppColors.textBlue),
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppColors.primaryBlue,
                  onPrimary: AppColors.white,
                  onSurface: AppColors.black,
                ),
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          setState(() {
            _birthDateController.text = pickedDate.toLocal().toString().split(' ')[0];
          });
        }
      },
    );
  }

  Widget _buildHeightField() {
    return TextFormField(
      controller: _heightController,
      validator: (value) {
        if (value == null || value.isEmpty) return "Debe ingresar una altura";
        if (double.tryParse(value) == null) return "Altura inválida";
        return null;
      },
      decoration: _buildInputDecoration("Altura (cm)", Icons.height),
      style: const TextStyle(color: AppColors.textBlue),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }

  Widget _buildWeightField() {
    return TextFormField(
      controller: _weightController,
      validator: (value) {
        if (value == null || value.isEmpty) return "Debe ingresar un peso";
        if (double.tryParse(value) == null) return "Peso inválido";
        return null;
      },
      decoration: _buildInputDecoration("Peso (kg)", Icons.monitor_weight),
      style: const TextStyle(color: AppColors.textBlue),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }

  Widget _buildSexField() {
    return DropdownButtonFormField<String>(
      value: _selectedSex,
      validator: (value) => value == null ? 'Seleccione un sexo' : null,
      items: const [
        DropdownMenuItem(value: 'masculino', child: Text('Masculino')),
        DropdownMenuItem(value: 'femenino', child: Text('Femenino')),
      ],
      onChanged: (value) {
        setState(() {
          _selectedSex = value;
        });
      },
      decoration: _buildInputDecoration("Sexo", CupertinoIcons.person_2),
      style: const TextStyle(color: AppColors.textBlue),
    );
  }

  Widget _buildSmokingField() {
    return DropdownButtonFormField<String>(
      value: _smokingStatus,
      validator: (value) => value == null ? 'Seleccione una opción' : null,
      items: const [
        DropdownMenuItem(value: 'activo', child: Text('Activo')),
        DropdownMenuItem(value: 'no', child: Text('No fumador')),
        DropdownMenuItem(value: 'exfumador', child: Text('Exfumador')),
      ],
      onChanged: (value) {
        setState(() {
          _smokingStatus = value!;
        });
      },
      decoration: _buildInputDecoration("Tabaquismo", CupertinoIcons.smoke),
      style: const TextStyle(color: AppColors.textBlue),
    );
  }

  Widget _buildMedicalHistoryCheckbox(String title, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(title, style: const TextStyle(color: AppColors.textBlue)),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primaryBlue,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildMedicalHistoryFields() {
    return Column(
      children: [
        _buildMedicalHistoryCheckbox("Hipertensión", _hasHypertension, (value) => setState(() => _hasHypertension = value!)),
        _buildMedicalHistoryCheckbox("Dislipidemia", _hasDyslipidemia, (value) => setState(() => _hasDyslipidemia = value!)),
        _buildMedicalHistoryCheckbox("Infarto Agudo de Miocardio", _hasMyocardialInfarction, (value) => setState(() => _hasMyocardialInfarction = value!)),
        _buildMedicalHistoryCheckbox("Arritmia", _hasArrhythmia, (value) => setState(() => _hasArrhythmia = value!)),
        _buildMedicalHistoryCheckbox("Miocardiopatía Dilatada", _hasDilatedCardiomyopathy, (value) => setState(() => _hasDilatedCardiomyopathy = value!)),
        _buildMedicalHistoryCheckbox("Miocardiopatía No Dilatada", _hasNonDilatedCardiomyopathy, (value) => setState(() => _hasNonDilatedCardiomyopathy = value!)),
      ],
    );
  }

  Widget _buildOtherMedicalHistoryField() {
    return TextFormField(
      controller: _otherMedicalHistoryController,
      decoration: _buildInputDecoration("Otros antecedentes (opcional)", CupertinoIcons.doc_text),
      style: const TextStyle(color: AppColors.textBlue),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      validator: (value) {
        if (value == null || value.isEmpty) return "Debe ingresar un correo";
        if (!isEmail(value)) return "Debe ingresar un correo válido";
        return null;
      },
      decoration: _buildInputDecoration("Correo", CupertinoIcons.mail),
      style: const TextStyle(color: AppColors.textBlue),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      obscureText: _obscureText,
      controller: _passwordController,
      validator: (value) {
        if (value == null || value.isEmpty) return "Debe ingresar una clave";
        if (value.length < 6) return "La clave debe tener al menos 6 caracteres";
        return null;
      },
      decoration: InputDecoration(
        labelText: "Clave",
        prefixIcon: const Icon(CupertinoIcons.lock, color: AppColors.primaryBlue),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: AppColors.primaryBlue,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
        labelStyle: const TextStyle(color: AppColors.primaryBlue),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryBlue),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryBlue),
        ),
      ),
      style: const TextStyle(color: AppColors.textBlue),
    );
  }

  Widget _buildLoginLink() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0), // Adjust as needed
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "¿Ya tienes cuenta?",
              style: TextStyle(color: AppColors.primaryBlue),
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
                  color: AppColors.accentBlue,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.accentBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}