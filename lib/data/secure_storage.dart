import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Preferances {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  writeSecureData(String key, String value) async {
    await storage.write(key: key, value: value);
    print("Data written successfully in Secure Storage");
  }

  readSecureData(String key) async {
    String data = await storage.read(key: key) ?? " No Data Present ";
    print("Data in Secure Storage is  :  " + data);
  }

  deleteSecureData(String key) async {
    await storage.delete(key: key);
    print("Data deleted sucessfully from Secure Storage");
  }

  Future<String?> getUsername() async {
    final value = await storage.read(key: 'username');
    return value;
  }
}
