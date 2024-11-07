import 'package:flutter/material.dart';
import 'package:lab2/pages/main_page.dart';
import 'package:lab2/pages/registration_page.dart';
import 'package:lab2/widgets/custom_text_field.dart';
import 'package:lab2/widgets/navigation_text_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  Future<void> _loginUser(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('userEmail');
    final savedPassword = prefs.getString('userPassword');

    if (emailController.text == savedEmail && passwordController.text 
    == savedPassword) {
      await prefs.setString('loggedInUserEmail', savedEmail ?? '');

      // Перевірка на mounted перед навігацією
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(builder: (context) => const MainPage()),
        );
      }
    } else {
      // Перевірка на mounted перед показом SnackBar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: 
          Text('Login failed: Invalid email or password'),),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Workout App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            CustomTextField(labelText: 'Email', controller: emailController),
            const SizedBox(height: 10),
            CustomTextField(
              labelText: 'Password',
              controller: passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _loginUser(context),
              child: const Text('Login', style: TextStyle(color: Colors.black)),
            ),
            const NavigationTextButton(
              text: 'Don\'t have an account? Sign up',
              destinationPage: RegistrationPage(),
            ),
          ],
        ),
      ),
    );
  }
}
