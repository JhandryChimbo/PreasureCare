import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Util {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveValue(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> getValue(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> removeValue(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> removeAll() async {
    await _storage.deleteAll();
  }
}