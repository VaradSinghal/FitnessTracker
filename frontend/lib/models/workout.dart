class Workout {
  final String? id;
  final String type;
  final int duration;
  final int? calories;
  final double? distance;
  final DateTime date;

  Workout({
    this.id,
    required this.type,
    required this.duration,
    this.calories,
    this.distance,
    required this.date,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['_id'],
      type: json['type'],
      duration: json['duration'],
      calories: json['calories'],
      distance: json['distance']?.toDouble(),
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'type': type,
      'duration': duration,
      if (calories != null) 'calories': calories,
      if (distance != null) 'distance': distance,
      'date': date.toIso8601String(),
    };
  }
}