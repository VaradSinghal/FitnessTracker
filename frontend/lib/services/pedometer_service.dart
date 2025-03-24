import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'api_service.dart';

class PedometerService {
  Stream<StepCount>? stepCountStream;
  int _lastStepCount = 0;
  final ApiService _apiService = ApiService();

  PedometerService(String token) {
    _initPedometer(token);
  }

  Future<void> _initPedometer(String token) async {
    var status = await Permission.activityRecognition.request();
    if (status.isGranted) {
      stepCountStream = Pedometer.stepCountStream;
      stepCountStream?.listen((event) {
        int newSteps = event.steps - _lastStepCount;
        if (newSteps > 0) {
          _lastStepCount = event.steps;
          _saveSteps(token, newSteps, DateTime.now());
        }
      }).onError((error) {
      });
    } else {
    }
  }

  Future<void> _saveSteps(String token, int steps, DateTime date) async {
    try {
      await _apiService.addSteps(token, steps, date);
    } catch (e) {
    }
  }
}