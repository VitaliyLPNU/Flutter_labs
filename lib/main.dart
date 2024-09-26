import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Rock, Paper, Scissors';
    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Варіанти вибору
  final List<String> choices = ['Rock', 'Paper', 'Scissors'];
  String? userChoice;
  String? computerChoice;
  String resultMessage = 'Make your move!';

  // Випадковий вибір комп'ютера
  void _makeComputerChoice() {
    computerChoice = choices[Random().nextInt(3)];
  }

  // Визначення переможця
  void _determineWinner() {
    if (userChoice == computerChoice) {
      resultMessage = 'It\'s a Draw!';
    } else if (
      (userChoice == 'Rock' && computerChoice == 'Scissors') ||
      (userChoice == 'Paper' && computerChoice == 'Rock') ||
      (userChoice == 'Scissors' && computerChoice == 'Paper')
    ) {
      resultMessage = 'You Win!';
    } else {
      resultMessage = 'You Lose!';
    }
  }

  // Обробка вибору користувача
  void _onUserChoice(String choice) {
    setState(() {
      userChoice = choice;
      _makeComputerChoice();
      _determineWinner();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Choose your move:',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            // Кнопки для вибору користувача
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: choices.map((choice) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () => _onUserChoice(choice),
                    child: Text(choice),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            // Відображення результатів
            Text(
              'You chose: ${userChoice ?? 'None'}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              'Computer chose: ${computerChoice ?? 'None'}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Text(
              resultMessage,
              style: TextStyle(
                color: resultMessage == 'You Win!'
                    ? Colors.green
                    : resultMessage == 'You Lose!'
                        ? Colors.red
                        : Colors.black,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
