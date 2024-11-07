abstract class StorageRepository {
  Future<void> saveUserData(String name, String email, String password);
  Future<Map<String, String>?> getUserData();
  Future<void> clearUserData();
}
