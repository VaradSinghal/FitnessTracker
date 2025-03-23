import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/step_counter.dart';
import '../widgets/stat_card.dart';
import '../providers/fitness_provider.dart';
import 'workout_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String token;

  DashboardScreen({required this.token});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FitnessProvider(token),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Fitness Tracker', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.blueAccent,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen())),
            ),
          ],
        ),
        body: Consumer<FitnessProvider>(
          builder: (context, provider, child) {
            final totalCalories = provider.workouts.fold<int>(0, (sum, w) => sum + (w.calories ?? 0));
            final totalDistance = provider.workouts.fold<double>(0, (sum, w) => sum + (w.distance ?? 0));
            final totalMinutes = provider.workouts.fold<int>(0, (sum, w) => sum + w.duration);

            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedOpacity(
                    opacity: provider.steps > 0 ? 1 : 0,
                    duration: Duration(milliseconds: 500),
                    child: StepCounter(steps: provider.steps, goal: provider.stepGoal),
                  ),
                  SizedBox(height: 20),
                  Text('Today\'s Stats', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      StatCard(title: 'Calories', value: '$totalCalories', icon: Icons.local_fire_department, color: Colors.red),
                      StatCard(title: 'Distance', value: '${totalDistance.toStringAsFixed(1)} km', icon: Icons.directions_run, color: Colors.blue),
                      StatCard(title: 'Active Min', value: '$totalMinutes', icon: Icons.timer, color: Colors.orange),
                      StatCard(title: 'Workouts', value: '${provider.workouts.length}', icon: Icons.fitness_center, color: Colors.green),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WorkoutScreen())),
                        icon: Icon(Icons.add),
                        label: Text('Log Workout'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HistoryScreen())),
                        icon: Icon(Icons.history),
                        label: Text('History'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}