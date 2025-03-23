import 'package:flutter/material.dart';
import '../models/workout.dart';

class WorkoutForm extends StatefulWidget {
  final Function(Workout) onSave;

  WorkoutForm({required this.onSave});

  @override
  _WorkoutFormState createState() => _WorkoutFormState();
}

class _WorkoutFormState extends State<WorkoutForm> {
  final _typeController = TextEditingController();
  final _durationController = TextEditingController();
  final _distanceController = TextEditingController();
  final _caloriesController = TextEditingController();

  void _submit() {
    final workout = Workout(
      id: '',
      type: _typeController.text,
      duration: int.parse(_durationController.text),
      distance: _distanceController.text.isNotEmpty ? double.parse(_distanceController.text) : null,
      calories: _caloriesController.text.isNotEmpty ? int.parse(_caloriesController.text) : null,
      date: DateTime.now(),
    );
    widget.onSave(workout);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _typeController,
          decoration: InputDecoration(labelText: 'Type (e.g., Running)', border: OutlineInputBorder()),
        ),
        SizedBox(height: 12),
        TextField(
          controller: _durationController,
          decoration: InputDecoration(labelText: 'Duration (minutes)', border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 12),
        TextField(
          controller: _distanceController,
          decoration: InputDecoration(labelText: 'Distance (km, optional)', border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 12),
        TextField(
          controller: _caloriesController,
          decoration: InputDecoration(labelText: 'Calories (optional)', border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 20),
        Center(
          child: ElevatedButton.icon(
            onPressed: _submit,
            icon: Icon(Icons.save),
            label: Text('Save Workout'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
          ),
        ),
      ],
    );
  }
}