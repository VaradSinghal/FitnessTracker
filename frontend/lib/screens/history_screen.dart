import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../providers/fitness_provider.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _page = 1;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FitnessProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('History', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: provider.workouts.length + provider.stepHistory.length,
              itemBuilder: (context, index) {
                return AnimatedOpacity(
                  opacity: 1,
                  duration: Duration(milliseconds: 300),
                  child: index < provider.stepHistory.length
                      ? ListTile(
                          title: Text('Steps: ${provider.stepHistory[index].steps}', style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(DateFormat.yMMMd().format(provider.stepHistory[index].date)),
                          leading: Icon(Icons.directions_walk, color: Colors.green),
                        )
                      : ListTile(
                          title: Text('${provider.workouts[index - provider.stepHistory.length].type} - ${provider.workouts[index - provider.stepHistory.length].duration} min'),
                          subtitle: Text(DateFormat.yMMMd().format(provider.workouts[index - provider.stepHistory.length].date)),
                          leading: Icon(Icons.fitness_center, color: Colors.blue),
                        ),
                );
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: EdgeInsets.all(16),
              child: SpinKitCircle(color: Colors.blueAccent),
            ),
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () async {
                setState(() => _isLoading = true);
                await provider.fetchWorkouts(++_page, 10);
                await provider.fetchSteps(_page, 10);
                setState(() => _isLoading = false);
              },
              child: Text('Load More'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }
}