import 'package:flutter/material.dart';
import 'package:lab2/pages/login_page.dart';
import 'package:lab2/pages/main_page.dart';
import 'package:lab2/pages/registration_page.dart';
import 'package:lab2/pages/training_page.dart'; // Додайте цей імпорт
import 'package:lab2/pages/user_profile_page.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const MainPage(),
  '/login': (context) =>  LoginPage(),
  '/registration': (context) =>   const RegistrationPage(),
  '/profile': (context) => const UserProfilePage(),
  '/training': (context) =>   const TrainingPage(), // Додайте цей маршрут
};
