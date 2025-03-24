import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../providers/fitness_provider.dart';

class WorkoutScreen extends StatefulWidget {
  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final _typeController = TextEditingController();
  final _durationController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _distanceController = TextEditingController();
  bool _isTracking = false;

  void _startTracking(BuildContext context) {
    Provider.of<FitnessProvider>(context, listen: false).startTrackingWorkout();
    setState(() {
      _isTracking = true;
    });
  }

  void _stopTracking(BuildContext context) {
    final provider = Provider.of<FitnessProvider>(context, listen: false);
    final distance = provider.stopTrackingWorkout();
    setState(() {
      _isTracking = false;
      _distanceController.text = distance.toStringAsFixed(2);
    });
  }

  void _logWorkout(BuildContext context) {
    // Validate inputs
    if (_typeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a workout type')),
      );
      return;
    }
    if (_durationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the duration')),
      );
      return;
    }
    int? duration;
    try {
      duration = int.parse(_durationController.text);
      if (duration <= 0) {
        throw FormatException('Duration must be greater than 0');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid duration (positive number)')),
      );
      return;
    }

    final provider = Provider.of<FitnessProvider>(context, listen: false);
    final workout = Workout(
      type: _typeController.text,
      duration: duration,
      calories: int.tryParse(_caloriesController.text),
      distance: double.tryParse(_distanceController.text),
      date: DateTime.now(),
    );
   
    provider.addWorkout(workout);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Workout', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _typeController,
                decoration: InputDecoration(
                  labelText: 'Workout Type (e.g., Running)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _durationController,
                decoration: InputDecoration(
                  labelText: 'Duration (minutes)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12),
              TextField(
                controller: _caloriesController,
                decoration: InputDecoration(
                  labelText: 'Calories Burned (optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12),
              TextField(
                controller: _distanceController,
                decoration: InputDecoration(
                  labelText: 'Distance (km, optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isTracking ? null : () => _startTracking(context),
                    icon: Icon(Icons.play_arrow),
                    label: Text('Start Tracking'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                  ElevatedButton.icon(
                    onPressed: _isTracking ? () => _stopTracking(context) : null,
                    icon: Icon(Icons.stop),
                    label: Text('Stop Tracking'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => _logWorkout(context),
                  icon: Icon(Icons.save),
                  label: Text('Log Workout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _typeController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    _distanceController.dispose();
    super.dispose();
  }
}