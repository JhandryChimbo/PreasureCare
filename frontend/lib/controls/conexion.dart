import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:frontend/controls/util/util.dart';
import 'package:frontend/controls/backendService/GenericAnswer.dart';

class Conexion {
  final String URL = 'http://';

  static bool NO_TOKEN = false;

  Future<GenericAnswer> solicitudGet(String recurso, bool token) async {
    Map<String, String> _header = {"Content-Type": "application/json"};

    if (token) {
      Util util = Util();
      String? tokenA = await util.getValue("token");
      _header = {
        "Content-Type": "application/json",
        "anime-token": tokenA.toString(),
      };
    }

    final String _url = URL + recurso;
    final uri = Uri.parse(_url);

    try {
      final response = await http.get(uri, headers: _header);

      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          return _response(404, "Recurso no encontrado", []);
        } else {
          Map<dynamic, dynamic> mapa = jsonDecode(response.body);
          return _response(mapa['code'], mapa['msg'], mapa['datos']);
        }
      } else {
        log(response.body);
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        return _response(mapa['code'], mapa['msg'], mapa['datos']);
      }
    } catch (e) {
      return _response(500, "Error Inesperado", []);
    }
  }

    GenericAnswer _response(int code, String msg, dynamic data) {
    var respuesta = GenericAnswer(msg: '', code: 0, data: {});
    respuesta.code = code;
    respuesta.data = data;
    respuesta.msg = msg;
    return respuesta;
  }
}
