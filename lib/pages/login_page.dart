import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lab2/pages/main_page.dart';
import 'package:lab2/pages/registration_page.dart';
import 'package:lab2/widgets/custom_text_field.dart';
import 'package:lab2/widgets/navigation_text_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> result) {
        setState(() {
          isConnected = result.isNotEmpty && 
          result.first != ConnectivityResult.none;
        });
      },
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _loginUser(BuildContext context) async {
    if (!isConnected) {
      _showNoInternetDialog(context);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('userEmail');
    final savedPassword = prefs.getString('userPassword');

    if (emailController.text == savedEmail && passwordController.text ==
     savedPassword) {
      await prefs.setString('loggedInUserEmail', savedEmail ?? '');
      _showLoginSuccessDialog(context);
    } else {
      _showLoginFailedDialog(context);
    }
  }

  void _showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Internet Connection'),
        content: 
        const Text('Please check your internet connection and try again.'),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showLoginSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Successful'),
        content: const Text('You have successfully logged in.'),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(builder: (context) => const MainPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showLoginFailedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Failed'),
        content: const Text('Invalid email or password. Please try again.'),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
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
