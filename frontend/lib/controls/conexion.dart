import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:frontend/controls/util/util.dart';
import 'package:frontend/controls/backendService/GenericAnswer.dart';

class Conexion {
  static const String URL = 'https://preasurecare.onrender.com/pressure/';
  static const bool NO_TOKEN = false; //p-token

  Future<GenericAnswer> solicitudGet(String recurso, bool token) async {
    final Map<String, String> header = {"Content-Type": "application/json"};

    if (token) {
      final Util util = Util();
      final String? tokenAux = await util.getValue("token");
      header.addAll({
        "Content-Type": "application/json",
        "p-token": tokenAux.toString(),
      });
    }

    final String url = URL + recurso;
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri, headers: header);
      log(response.body);

      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          return _response(404, "Recurso no encontrado", []);
        } else {
          final Map<String, dynamic> mapa = jsonDecode(response.body);
          return _response(mapa['code'], mapa['msg'], mapa['datos']);
        }
      } else {
        log(response.body);
        final Map<String, dynamic> mapa = jsonDecode(response.body);
        return _response(mapa['code'], mapa['msg'], mapa['datos']);
      }
    } catch (e) {
      log('Error: $e');
      return _response(500, "Error Inesperado", []);
    }
  }

  Future<GenericAnswer> solicitudPost(
      String recurso, bool token, Map<dynamic, dynamic> mapa) async {
    Map<String, String> header = {'Content-Type': 'application/json'};
    if (token) {
      Util util = Util();
      String? token = await util.getValue('token');
      header = {
        'Content-Type': 'application/json',
        'p-token': token.toString(),
      };
    }

    final String url = URL + recurso;
    final uri = Uri.parse(url);

    try {
      final response = await http.post(
        uri,
        headers: header,
        body: jsonEncode(mapa),
      );

      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          return _response(404, "Recurso no encontrado -  Solicitud", []);
        } else {
          Map<dynamic, dynamic> mapa = jsonDecode(response.body);
          return _response(mapa['code'], mapa['msg'], mapa['data']);
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        return _response(mapa['code'], mapa['msg'], mapa['data']);
      }
    } catch (e) {
      return _response(500, "Error inesperado", []);
    }
  }

  GenericAnswer _response(int code, String msg, dynamic data) {
    return GenericAnswer(
      code: code,
      msg: msg,
      data: data,
    );
  }
}
