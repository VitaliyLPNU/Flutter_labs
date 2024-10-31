import 'package:lab2/auth/storage_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageRepository implements StorageRepository {
  @override
  Future<void> saveUserData(String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  @override
  Future<Map<String, String>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name');
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    if (name != null && email != null && password != null) {
      return {'name': name, 'email': email, 'password': password};
    }
    return null;
  }

  @override
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
