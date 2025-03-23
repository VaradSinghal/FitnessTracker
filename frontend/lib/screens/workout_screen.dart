import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../providers/fitness_provider.dart';
import '../widgets/workout_form.dart';

class WorkoutScreen extends StatefulWidget {
  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  bool _isTracking = false;

  void _toggleTracking(FitnessProvider provider) {
    setState(() {
      _isTracking = !_isTracking;
      if (_isTracking) {
        provider.startTrackingWorkout();
      } else {
        final distance = provider.stopTrackingWorkout();
        Navigator.pop(context, Workout(
          id: '',
          type: 'Running',
          duration: 0,
          distance: distance,
          date: DateTime.now(),
        ));
      }
    });
  }

  void _saveManualWorkout(Workout workout, FitnessProvider provider) {
    provider.addWorkout(workout);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FitnessProvider>(context);
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
              Text('Manual Entry', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              WorkoutForm(onSave: (workout) => _saveManualWorkout(workout, provider)),
              SizedBox(height: 20),
              Divider(),
              Text('Live Tracking', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              if (_isTracking)
                Column(
                  children: [
                    Text('Distance: ${provider.currentDistance.toStringAsFixed(2)} km', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                  ],
                ),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => _toggleTracking(provider),
                  icon: Icon(_isTracking ? Icons.stop : Icons.play_arrow),
                  label: Text(_isTracking ? 'Stop Tracking' : 'Start Tracking'),
                  style: ElevatedButton.styleFrom(backgroundColor: _isTracking ? Colors.red : Colors.green, padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}