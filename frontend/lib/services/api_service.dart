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
     
      rethrow;
    }
  }

  Future<void> logout(String token) async {
    try {
      
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/logout'),
        headers: {...ApiConfig.headers, 'x-auth-token': token},
      ).timeout(Duration(seconds: 60));
      if (response.statusCode != 200) {
        throw Exception('Logout failed: ${response.body}');
      }
    } catch (e) {
      
      rethrow;
    }
  }

  Future<void> addSteps(String token, int steps, DateTime date) async {
    try {
     ;
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/steps'),
        headers: {...ApiConfig.headers, 'x-auth-token': token},
        body: jsonEncode({'steps': steps, 'date': date.toIso8601String()}),
      ).timeout(Duration(seconds: 60));
      if (response.statusCode != 201) {
        throw Exception('Failed to add steps: ${response.body}');
      }
    } catch (e) {
     
      rethrow;
    }
  }

  Future<List<StepData>> getSteps(String token, int page, int limit) async {
    try {
      
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/steps?page=$page&limit=$limit'),
        headers: {...ApiConfig.headers, 'x-auth-token': token},
      ).timeout(Duration(seconds: 60));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
       
        return (data['steps'] as List).map((json) => StepData.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        
        await _storage.delete(key: 'token');
        throw Exception('Unauthorized: Invalid token');
      } else {
        throw Exception('Failed to load steps: ${response.body}');
      }
    } catch (e) {
   
      rethrow;
    }
  }

  Future<void> addWorkout(String token, Workout workout) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/workouts'),
        headers: {...ApiConfig.headers, 'x-auth-token': token},
        body: jsonEncode(workout.toJson()),
      ).timeout(Duration(seconds: 60));
      if (response.statusCode == 201) {
        
        return;
      } else if (response.statusCode == 401) {
       
        await _storage.delete(key: 'token');
        throw Exception('Unauthorized: Invalid token');
      } else {
        throw Exception('Failed to add workout: ${response.body}');
      }
    } catch (e) {
      
      rethrow;
    }
  }

  Future<List<Workout>> getWorkouts(String token, int page, int limit) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/workouts?page=$page&limit=$limit'),
        headers: {...ApiConfig.headers, 'x-auth-token': token},
      ).timeout(Duration(seconds: 60));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['workouts'] as List).map((json) => Workout.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        await _storage.delete(key: 'token');
        throw Exception('Unauthorized: Invalid token');
      } else {
        throw Exception('Failed to load workouts: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }
}