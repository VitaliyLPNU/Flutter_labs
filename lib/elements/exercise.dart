class Exercise {
  final String name;
  final int repetitions;
  final double weight;

  Exercise({
    required this.name,
    required this.repetitions,
    this.weight = 0.0,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'repetitions': repetitions,
      'weight': weight,
    };
  }

  static Exercise fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] as String, // Явно вказуємо тип
      repetitions: json['repetitions'] as int, // Явно вказуємо тип
      weight: (json['weight'] as num).toDouble(), // Приводимо до double
    );
  }
}
