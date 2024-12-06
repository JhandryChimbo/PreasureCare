import 'dart:convert';
import 'package:frontend/controls/conexion.dart';
import 'package:frontend/controls/backendService/model/login.dart';
import 'package:http/http.dart' as http;

class FacadeServices {
  final Conexion conexion = Conexion();

  Future<Login> login(Map<String, String> credentials) async {
    const Map<String, String> headers = {"Content-Type": "application/json"};
    const String url = '${Conexion.URL}login';
    final uri = Uri.parse(url);
    Login loginResponse = Login(msg: '', code: 0, data: {});

    try {
      final response = await http.post(uri, headers: headers, body: jsonEncode(credentials));
      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        loginResponse = Login(msg: responseBody['msg'], code: responseBody['code'], data: responseBody['data']);
      } else {
        loginResponse = Login(
          msg: responseBody.containsKey('msg') ? responseBody['msg'] : "Error desconocido",
          code: response.statusCode,
          data: responseBody['data'] ?? {},
        );
      }
    } catch (e) {
      loginResponse = Login(msg: "Error Inesperado", code: 500, data: {});
    }

    return loginResponse;
  }

  Future<Login> register(Map<String, String> credentials) async {
    const Map<String, String> headers = {"Content-Type": "application/json"};
    const String url = '${Conexion.URL}persona/save';
    final uri = Uri.parse(url);
    Login loginResponse = Login(msg: '', code: 0, data: {});

    try {
      final response = await http.post(uri, headers: headers, body: jsonEncode(credentials));
      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        loginResponse = Login(msg: responseBody['msg'], code: responseBody['code'], data: responseBody['data']);
      } else {
        loginResponse = Login(
          msg: responseBody.containsKey('msg') ? responseBody['msg'] : "Error desconocido",
          code: response.statusCode,
          data: responseBody['data'] ?? {},
        );
      }
    } catch (e) {
      loginResponse = Login(msg: "Error Inesperado", code: 500, data: {});
    }

    return loginResponse;
  }
}
