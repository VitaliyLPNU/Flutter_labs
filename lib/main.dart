import 'package:flutter/material.dart';
import 'package:lab2/elements/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Тепер це вказується в appRoutes
      routes: appRoutes, // Використовуємо маршрути з appRoutes
    );
  }
}
