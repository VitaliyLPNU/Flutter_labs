import 'package:connectivity_plus/connectivity_plus.dart'; // Для моніторингу з'єднання
import 'package:flutter/material.dart';
import 'package:lab2/pages/login_page.dart'; // Ваш файл для сторінки логіну
import 'package:lab2/pages/main_page.dart'; // Головна сторінка після авторизації
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  // Перевірка статусу інтернет-з'єднання
  Future<bool> _isInternetAvailable() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  // Перевірка статусу авторизації та підключення до мережі
  Future<void> _checkLoginStatus(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userEmail = prefs.getString('loggedInUserEmail');

    // Перевіряємо наявність даних для автологіну
    if (userEmail != null && userEmail.isNotEmpty) {
      // Перевірка з'єднання з інтернетом
      final bool isConnected = await _isInternetAvailable();

      if (isConnected) {
        // Якщо з'єднання є, переходимо на головну сторінку
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()),
          );
        });
      } else {
        // Якщо немає з'єднання, показуємо діалог
        _showNoConnectionDialog(context);
      }
    } else {
      // Якщо користувач не авторизований, переходимо на сторінку логіну
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    }
  }

  // Діалогове вікно, яке з'являється при відсутності інтернет-з'єднання
  void _showNoConnectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Internet Connection'),
        content: const Text('Please connect to the internet to continue.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Викликаємо перевірку статусу авторизації
    _checkLoginStatus(context);

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Checking login status...'),
          ],
        ),
      ),
    );
  }
}
