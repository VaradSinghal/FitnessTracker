import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';
import '../models/step_data.dart';
import '../models/workout.dart';

class ApiService {
  final _storage = FlutterSecureStorage();

  Future<String> register(String email, String password, String name) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/register'),
        headers: ApiConfig.headers,
        body: jsonEncode({'email': email, 'password': password, 'name': name}),
      ).timeout(Duration(seconds: 60));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['token'];
      } else {
        throw Exception('Registration failed: ${response.body}');
      }
    } catch (e) {
      print('Register error: $e');
      rethrow;
    }
  }

  Future<String> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/login'),
        headers: ApiConfig.headers,
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(Duration(seconds: 60));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['token'];
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  Future<void> logout(String token) async {
    try {
      print('Logging out with token: $token');
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/logout'),
        headers: {...ApiConfig.headers, 'x-auth-token': token},
      ).timeout(Duration(seconds: 60));
      if (response.statusCode != 200) {
        throw Exception('Logout failed: ${response.body}');
      }
    } catch (e) {
      print('Logout error: $e');
      rethrow;
    }
  }

  Future<List<StepData>> getSteps(String token, int page, int limit) async {
    try {
      print('Fetching steps with token: $token');
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/steps?page=$page&limit=$limit'),
        headers: {...ApiConfig.headers, 'x-auth-token': token},
      ).timeout(Duration(seconds: 60));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Steps fetched: ${data['steps']}');
        return (data['steps'] as List).map((json) => StepData.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        print('Unauthorized error: ${response.body}');
        await _storage.delete(key: 'token');
        throw Exception('Unauthorized: Invalid token');
      } else {
        throw Exception('Failed to load steps: ${response.body}');
      }
    } catch (e) {
      print('Get steps error: $e');
      rethrow;
    }
  }

  Future<void> addWorkout(String token, Workout workout) async {
    try {
      print('Adding workout with token: $token');
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/workouts'),
        headers: {...ApiConfig.headers, 'x-auth-token': token},
        body: jsonEncode(workout.toJson()),
      ).timeout(Duration(seconds: 60));
      if (response.statusCode == 201) {
        return;
      } else if (response.statusCode == 401) {
        print('Unauthorized error: ${response.body}');
        await _storage.delete(key: 'token');
        throw Exception('Unauthorized: Invalid token');
      } else {
        throw Exception('Failed to add workout: ${response.body}');
      }
    } catch (e) {
      print('Add workout error: $e');
      rethrow;
    }
  }

  Future<List<Workout>> getWorkouts(String token, int page, int limit) async {
    try {
      print('Fetching workouts with token: $token');
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/workouts?page=$page&limit=$limit'),
        headers: {...ApiConfig.headers, 'x-auth-token': token},
      ).timeout(Duration(seconds: 60));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Workouts fetched: ${data['workouts']}');
        return (data['workouts'] as List).map((json) => Workout.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        print('Unauthorized error: ${response.body}');
        await _storage.delete(key: 'token');
        throw Exception('Unauthorized: Invalid token');
      } else {
        throw Exception('Failed to load workouts: ${response.body}');
      }
    } catch (e) {
      print('Get workouts error: $e');
      rethrow;
    }
  }
}