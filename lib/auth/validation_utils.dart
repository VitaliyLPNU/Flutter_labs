class ValidationUtils {
  static bool isValidEmail(String email) => email.contains('@');
  static bool isValidName(String name) => !RegExp(r'[0-9]').hasMatch(name);
  static bool isValidPassword(String password) => password.length >= 6;
}
