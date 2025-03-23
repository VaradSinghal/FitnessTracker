import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../providers/fitness_provider.dart';
import 'package:intl/intl.dart';
import 'login_screen.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _page = 1;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final provider = Provider.of<FitnessProvider>(context, listen: false);
      await provider.fetchSteps(1, 10);
      await provider.fetchWorkouts(1, 10);
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      if (_error!.contains('Unauthorized')) {
        // Redirect to LoginScreen if token is invalid
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final provider = Provider.of<FitnessProvider>(context, listen: false);
      await provider.fetchWorkouts(++_page, 10);
      await provider.fetchSteps(_page, 10);
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      if (_error!.contains('Unauthorized')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FitnessProvider>(context);
    final totalItems = provider.workouts.length + provider.stepHistory.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('History', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading && totalItems == 0
                ? Center(child: SpinKitCircle(color: Colors.blueAccent))
                : _error != null
                    ? Center(child: Text('Error: $_error', style: TextStyle(color: Colors.red)))
                    : totalItems == 0
                        ? Center(child: Text('No history available'))
                        : ListView.builder(
                            itemCount: totalItems,
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
          if (_isLoading && totalItems > 0)
            Padding(
              padding: EdgeInsets.all(16),
              child: SpinKitCircle(color: Colors.blueAccent),
            ),
          if (_error == null && totalItems > 0)
            Padding(
              padding: EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _loadMore,
                child: Text('Load More'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              ),
            ),
        ],
      ),
    );
  }
}