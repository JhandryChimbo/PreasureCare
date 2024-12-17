import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  static String? getUserRole(String token) {
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken['rol'];
    } catch (e) {
      print("Error decodificando el token: $e");
      return null;
    }
  }

  static bool isTokenExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      print("Error decodificando el token: $e");
      return true;
    }
  }

  static String? getUserId(String token) {
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken['external'];
    } catch (e) {
      print("Error decodificando el token: $e");
      return null;
    }
  }
}
