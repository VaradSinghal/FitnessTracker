import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'providers/fitness_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = FlutterSecureStorage();
  final token = await storage.read(key: 'token');
  
  runApp(MyApp(initialToken: token));
}

class MyApp extends StatelessWidget {
  final String? initialToken;

  MyApp({this.initialToken});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FitnessProvider(initialToken ?? ''),
      child: MaterialApp(
        title: 'Fitness Tracker',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: initialToken != null ? DashboardScreen(token: initialToken!) : LoginScreen(),
      ),
    );
  }
}