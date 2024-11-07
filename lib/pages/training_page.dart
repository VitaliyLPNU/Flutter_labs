import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lab2/elements/exercise.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  List<Map<String, dynamic>> trainings = [];
  final TextEditingController _trainingNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTrainings();
  }

Future<void> _loadTrainings() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString('trainings');

  if (jsonString != null) {
    try {
      // Decode and cast to a List<Map<String, dynamic>>
      final List<dynamic> decodedData 
      = json.decode(jsonString) as List<dynamic>;
      setState(() {
        trainings = decodedData.map((item) {
          // Ensure nested lists are cast correctly to 
          //List<Map<String, dynamic>>
          return {
            'name': item['name'] as String,
            'exercises': (item['exercises'] as List<dynamic>)
                .map((exercise) =>
                 Map<String, dynamic>.from(exercise as Map<String, dynamic>),)
                .toList(),
          };
        }).toList();
      });
    } catch (e) {
      setState(() {
        trainings = []; // Fallback to an empty list if parsing fails
      });
    }
  }
}

  Future<void> _saveTrainings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(trainings);
    await prefs.setString('trainings', jsonString);
  }

  void _addTraining() {
    final newTraining = {
      'name': _trainingNameController.text,
      'exercises': <Map<String, dynamic>>[],
    };
    setState(() {
      trainings.add(newTraining); 
      _trainingNameController.clear();
    });
    _saveTrainings();
  }

  void _deleteTraining(int index) {
    setState(() {
      trainings.removeAt(index);
    });
    _saveTrainings();
  }

  void _openTrainingDetails(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrainingDetailsPage(
          training: trainings[index],
          onUpdate: (updatedTraining) {
            setState(() {
              trainings[index] = updatedTraining;
            });
            _saveTrainings();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _trainingNameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter training name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTraining,
                  child: const Text('Add Training'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: trainings.length,
              itemBuilder: (context, index) {
                final training = trainings[index];
                return Card(
                  child: ListTile(
                    title: Text(training['name'] as String),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteTraining(index),
                    ),
                    onTap: () => _openTrainingDetails(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TrainingDetailsPage extends StatefulWidget {
  final Map<String, dynamic> training;
  final ValueChanged<Map<String, dynamic>> onUpdate;

  const TrainingDetailsPage({required this.training, required this.onUpdate, 
  super.key,});

  @override
  _TrainingDetailsPageState createState() => _TrainingDetailsPageState();
}

class _TrainingDetailsPageState extends State<TrainingDetailsPage> {
  final TextEditingController _exerciseNameController = TextEditingController();
  final TextEditingController _repetitionsController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  void _addExercise() {
    final newExercise = Exercise(
      name: _exerciseNameController.text,
      repetitions: int.tryParse(_repetitionsController.text) ?? 0,
      weight: double.tryParse(_weightController.text) ?? 0.0,
    );
    setState(() {
      (widget.training['exercises'] as List).add(newExercise.toJson());
      widget.onUpdate(widget.training);
    });
    _exerciseNameController.clear();
    _repetitionsController.clear();
    _weightController.clear();
  }

  void _deleteExercise(int index) {
    setState(() {
      (widget.training['exercises'] as List).removeAt(index);
      widget.onUpdate(widget.training);
    });
  }

  @override
  Widget build(BuildContext context) {
    final exercises = widget.training['exercises'] as 
    List<Map<String, dynamic>>;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.training['name'] as String),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _exerciseNameController,
                    decoration: const InputDecoration(
                      hintText: 'Exercise name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _repetitionsController,
                    decoration: const InputDecoration(
                      hintText: 'Repetitions',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    decoration: const InputDecoration(
                      hintText: 'Weight (optional)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addExercise,
                  child: const Text('Add Exercise'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return Card(
                  child: ListTile(
                    title: Text('${exercise['name']}'),
                    subtitle: Text(
                        'Reps: ${exercise['repetitions']}, Weight: ${exercise
                        ['weight']} kg'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteExercise(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
