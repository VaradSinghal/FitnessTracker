import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fitness_provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _goalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<FitnessProvider>(context, listen: false);
    _goalController.text = provider.stepGoal.toString();
  }

  void _saveSettings(FitnessProvider provider) {
    provider.setStepGoal(int.parse(_goalController.text));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FitnessProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Step Goal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(
              controller: _goalController,
              decoration: InputDecoration(
                labelText: 'Daily Step Goal',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _saveSettings(provider),
                icon: Icon(Icons.save),
                label: Text('Save'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}