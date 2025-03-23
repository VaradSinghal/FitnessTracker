import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/step_data.dart';
import '../models/workout.dart';

class ApiService {
  Future<String> register(String email, String password, String name) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/auth/register'),
      headers: ApiConfig.headers,
      body: jsonEncode({'email': email, 'password': password, 'name': name}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['token'];
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/auth/login'),
      headers: ApiConfig.headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['token'];
    } else {
      throw Exception('Login failed');
    }
  }

  Future<List<StepData>> getSteps(String token, int page, int limit) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/steps?page=$page&limit=$limit'),
      headers: {...ApiConfig.headers, 'x-auth-token': token},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['steps'] as List).map((json) => StepData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load steps');
    }
  }

  Future<void> addWorkout(String token, Workout workout) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/workouts'),
      headers: {...ApiConfig.headers, 'x-auth-token': token},
      body: jsonEncode(workout.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add workout');
    }
  }

  Future<List<Workout>> getWorkouts(String token, int page, int limit) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/workouts?page=$page&limit=$limit'),
      headers: {...ApiConfig.headers, 'x-auth-token': token},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['workouts'] as List).map((json) => Workout.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load workouts');
    }
  }
}