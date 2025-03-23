class Workout {
  final String id;
  final String type;
  final int duration;
  final double? distance;
  final int? calories;
  final DateTime date;

  Workout({
    required this.id,
    required this.type,
    required this.duration,
    this.distance,
    this.calories,
    required this.date,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['_id'],
      type: json['type'],
      duration: json['duration'],
      distance: json['distance']?.toDouble(),
      calories: json['calories'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'duration': duration,
        'distance': distance,
        'calories': calories,
      };
}