class StepData {
  final String id;
  final int steps;
  final DateTime date;

  StepData({required this.id, required this.steps, required this.date});

  factory StepData.fromJson(Map<String, dynamic> json) {
    return StepData(
      id: json['_id'],
      steps: json['steps'],
      date: DateTime.parse(json['date']),
    );
  }
}