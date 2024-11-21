import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Метод для отримання вправ для конкретного типу
  Future<List<Map<String, dynamic>>> fetchExercises(String type) async {
    const String apiKey = 'arZdrqzOset8cL8nvWeriQ==TamyKn402MsA2nf4';
    final apiUrl = 'https://api.api-ninjas.com/v1/exercises?type=$type';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'X-Api-Key': apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body) as List<dynamic>;
      // Повертаємо список мап із деталями вправ
      return data.map((exercise) => exercise as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load exercises for type: $type');
    }
  }

  // Метод для відображення вправ за категоріями
  Future<Map<String, List<Map<String, dynamic>>>> fetchAllExercises() async {
    final cardio = await fetchExercises('cardio');
    final strength = await fetchExercises('strength');
    final stretching = await fetchExercises('stretching');
    return {
      'Cardio': cardio,
      'Strength': strength,
      'Stretching': stretching,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Exercises'),
      ),
      body: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
        future: fetchAllExercises(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final exercisesByType = snapshot.data!;
            return ListView.builder(
              itemCount: exercisesByType.keys.length,
              itemBuilder: (context, index) {
                final type = exercisesByType.keys.elementAt(index);
                final exercises = exercisesByType[type]!;

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      ...exercises.map(ExerciseCard.new),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No exercises available'));
          }
        },
      ),
      backgroundColor: Colors.white,
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final Map<String, dynamic> exercise;

  const ExerciseCard(this.exercise, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exercise['name'] as String? ?? 'Unknown Name',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Muscle: ${exercise['muscle'] as String? ?? 'N/A'}',
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic, // Додаємо курсив
              ),
            ),
            Text(
              'Equipment: ${exercise['equipment'] as String? ?? 'N/A'}',
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic, // Додаємо курсив
              ),
            ),
            Text(
              'Difficulty: ${exercise['difficulty'] as String? ?? 'N/A'}',
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic, // Додаємо курсив
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Instructions: ${exercise['instructions'] ?? 
              'No instructions available.'}',
              style: const TextStyle(fontSize: 14, color:
               Color.fromARGB(255, 31, 28, 28),),
            ),
          ],
        ),
      ),
    );
  }
}
