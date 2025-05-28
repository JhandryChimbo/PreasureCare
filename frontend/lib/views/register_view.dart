import 'package:flutter/material.dart';
import 'package:PressureCare/services/register_service.dart';

const kPrimaryColor = Color(0xFF2897FF);

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  int _pasoActual = 0;
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final nombreCtrl = TextEditingController();
  final apellidoCtrl = TextEditingController();
  final fechaNacCtrl = TextEditingController();
  final correoCtrl = TextEditingController();
  final claveCtrl = TextEditingController();
  final alturaCtrl = TextEditingController();
  final pesoCtrl = TextEditingController();
  String? sexo;
  String tabaquismo = 'no';
  bool hipertension = false;
  bool dislipidemia = false;
  bool infarto = false;
  bool arritmia = false;
  bool miocardiopatiaDil = false;
  bool miocardiopatiaNoDil = false;
  final otrosCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Registro paso a paso'),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: kPrimaryColor,
                  secondary: kPrimaryColor,
                ),
            inputDecorationTheme: const InputDecorationTheme(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor),
              ),
              labelStyle: TextStyle(color: kPrimaryColor),
            ),
          ),
          child: Stepper(
            type: StepperType.vertical,
            currentStep: _pasoActual,
            onStepContinue: () async {
              bool isValid = false;

              switch (_pasoActual) {
                case 0:
                  isValid = nombreCtrl.text.isNotEmpty &&
                      apellidoCtrl.text.isNotEmpty &&
                      fechaNacCtrl.text.isNotEmpty;
                  break;
                case 1:
                  isValid =
                      correoCtrl.text.isNotEmpty && claveCtrl.text.isNotEmpty;
                  break;
                case 2:
                  isValid = alturaCtrl.text.isNotEmpty &&
                      pesoCtrl.text.isNotEmpty &&
                      sexo != null;
                  break;
                case 3:
                  // En el paso 3 no se requiere validación obligatoria,
                  // pero puedes agregar lógica si quieres validar al menos una selección
                  isValid = true;
                  break;
              }

              if (!isValid) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Por favor, complete todos los campos.')),
                );
                return;
              }
              if (_pasoActual < 3) {
                setState(() => _pasoActual++);
              } else {
                if (_formKey.currentState!.validate()) {
                  setState(() {});
                  await RegisterService.registerUser(
                    context: context,
                    formKey: _formKey,
                    correoControl: correoCtrl,
                    claveControl: claveCtrl,
                    nombreControl: nombreCtrl,
                    apellidoControl: apellidoCtrl,
                    fechaNacControl: fechaNacCtrl,
                    alturaControl: alturaCtrl,
                    pesoControl: pesoCtrl,
                    sexoControl: TextEditingController(text: sexo ?? ''),
                    tabaquismoControl: TextEditingController(text: tabaquismo),
                    otrosAntecedentesControl: otrosCtrl,
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
                  setState(() {});
                }
              }
            },
            onStepCancel: () {
              if (_pasoActual > 0) {
                setState(() => _pasoActual--);
              }
            },
            controlsBuilder: (context, details) {
              return Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: details.onStepContinue,
                    child: Text(_pasoActual == 3 ? 'Registrar' : 'Siguiente'),
                  ),
                  if (_pasoActual > 0)
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: kPrimaryColor,
                      ),
                      onPressed: details.onStepCancel,
                      child: const Text('Atrás'),
                    ),
                ],
              );
            },
            steps: [
              Step(
                title: const Text('Datos personales',
                    style: TextStyle(color: kPrimaryColor)),
                isActive: _pasoActual >= 0,
                state: _pasoActual > 0 ? StepState.complete : StepState.indexed,
                content: Column(
                  children: [
                    TextFormField(
                      controller: nombreCtrl,
                      decoration: const InputDecoration(labelText: 'Nombres'),
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                    ),
                    TextFormField(
                      controller: apellidoCtrl,
                      decoration: const InputDecoration(labelText: 'Apellidos'),
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                    ),
                    TextFormField(
                      controller: fechaNacCtrl,
                      readOnly: true,
                      decoration: const InputDecoration(
                          labelText: 'Fecha de nacimiento'),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: kPrimaryColor,
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
                            fechaNacCtrl.text =
                                picked.toLocal().toString().split(' ')[0];
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              Step(
                title: const Text('Datos de cuenta',
                    style: TextStyle(color: kPrimaryColor)),
                isActive: _pasoActual >= 1,
                state: _pasoActual > 1 ? StepState.complete : StepState.indexed,
                content: Column(
                  children: [
                    TextFormField(
                      controller: correoCtrl,
                      decoration: const InputDecoration(labelText: 'Correo'),
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                    ),
                    TextFormField(
                      controller: claveCtrl,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Clave'),
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                    ),
                  ],
                ),
              ),
              Step(
                title: const Text('Datos biométricos',
                    style: TextStyle(color: kPrimaryColor)),
                isActive: _pasoActual >= 2,
                state: _pasoActual > 2 ? StepState.complete : StepState.indexed,
                content: Column(
                  children: [
                    TextFormField(
                      controller: alturaCtrl,
                      decoration:
                          const InputDecoration(labelText: 'Altura (cm)'),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                    ),
                    TextFormField(
                      controller: pesoCtrl,
                      decoration: const InputDecoration(labelText: 'Peso (kg)'),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                    ),
                    DropdownButtonFormField<String>(
                      value: sexo,
                      items: const [
                        DropdownMenuItem(
                            value: 'masculino', child: Text('Masculino')),
                        DropdownMenuItem(
                            value: 'femenino', child: Text('Femenino')),
                      ],
                      onChanged: (value) => setState(() => sexo = value),
                      decoration: const InputDecoration(labelText: 'Sexo'),
                      validator: (v) =>
                          v == null ? 'Seleccione una opción' : null,
                    ),
                  ],
                ),
              ),
              Step(
                title: const Text('Antecedentes médicos',
                    style: TextStyle(color: kPrimaryColor)),
                isActive: _pasoActual >= 3,
                state: _pasoActual == 3 ? StepState.editing : StepState.indexed,
                content: Column(
                  children: [
                    CheckboxListTile(
                      title: const Text('Hipertensión'),
                      value: hipertension,
                      activeColor: kPrimaryColor,
                      onChanged: (v) => setState(() => hipertension = v!),
                    ),
                    RadioListTile(
                      title: const Text('Tabaquismo activo'),
                      value: 'activo',
                      groupValue: tabaquismo,
                      activeColor: kPrimaryColor,
                      onChanged: (v) => setState(() => tabaquismo = v!),
                    ),
                    RadioListTile(
                      title: const Text('Tabaquismo no activo'),
                      value: 'no',
                      groupValue: tabaquismo,
                      activeColor: kPrimaryColor,
                      onChanged: (v) => setState(() => tabaquismo = v!),
                    ),
                    CheckboxListTile(
                      title: const Text('Dislipidemia'),
                      value: dislipidemia,
                      activeColor: kPrimaryColor,
                      onChanged: (v) => setState(() => dislipidemia = v!),
                    ),
                    CheckboxListTile(
                      title: const Text('Infarto agudo de miocardio'),
                      value: infarto,
                      activeColor: kPrimaryColor,
                      onChanged: (v) => setState(() => infarto = v!),
                    ),
                    CheckboxListTile(
                      title: const Text('Arritmia'),
                      value: arritmia,
                      activeColor: kPrimaryColor,
                      onChanged: (v) => setState(() => arritmia = v!),
                    ),
                    CheckboxListTile(
                      title: const Text('Miocardiopatía dilatada'),
                      value: miocardiopatiaDil,
                      activeColor: kPrimaryColor,
                      onChanged: (v) => setState(() => miocardiopatiaDil = v!),
                    ),
                    CheckboxListTile(
                      title: const Text('Miocardiopatía no dilatada'),
                      value: miocardiopatiaNoDil,
                      activeColor: kPrimaryColor,
                      onChanged: (v) =>
                          setState(() => miocardiopatiaNoDil = v!),
                    ),
                    TextFormField(
                      controller: otrosCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Otros antecedentes'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
