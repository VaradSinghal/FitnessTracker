import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/pedometer_service.dart';
import '../services/geolocation_service.dart';
import '../models/step_data.dart';
import '../models/workout.dart';

class FitnessProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final PedometerService _pedometerService = PedometerService();
  final GeolocationService _geolocationService = GeolocationService();
  int _steps = 0;
  List<StepData> _stepHistory = [];
  List<Workout> _workouts = [];
  String? _token;
  int _stepGoal = 10000;

  int get steps => _steps;
  List<StepData> get stepHistory => _stepHistory;
  List<Workout> get workouts => _workouts;
  int get stepGoal => _stepGoal;
  double get currentDistance => _geolocationService.currentDistance;

  FitnessProvider(String token) {
    _token = token;
    _initPedometer();
    fetchSteps(1, 10);
    fetchWorkouts(1, 10);
  }

  void _initPedometer() {
    _pedometerService.stepCountStream?.listen((event) {
      _steps = event.steps;
      notifyListeners();
    });
  }

  void setStepGoal(int goal) {
    _stepGoal = goal;
    notifyListeners();
  }

  Future<void> fetchSteps(int page, int limit) async {
    if (_token != null) {
      final newSteps = await _apiService.getSteps(_token!, page, limit);
      _stepHistory = [..._stepHistory, ...newSteps];
      notifyListeners();
    }
  }

  Future<void> addWorkout(Workout workout) async {
    if (_token != null) {
      await _apiService.addWorkout(_token!, workout);
      fetchWorkouts(1, 10);
    }
  }

  Future<void> fetchWorkouts(int page, int limit) async {
    if (_token != null) {
      final newWorkouts = await _apiService.getWorkouts(_token!, page, limit);
      _workouts = [..._workouts, ...newWorkouts];
      notifyListeners();
    }
  }

  void startTrackingWorkout() {
    _geolocationService.startTracking();
    notifyListeners();
  }

  double stopTrackingWorkout() {
    final distance = _geolocationService.stopTracking();
    notifyListeners();
    return distance;
  }

  void reset() {
    _steps = 0;
    _stepHistory = [];
    _workouts = [];
    _token = null;
    _stepGoal = 10000;
    notifyListeners();
  }
}