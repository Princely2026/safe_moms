import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'screens/onboarding_screen.dart';
import 'screens/dashboard_screen.dart';
import 'database_helper.dart';

void main() async {
  // Critical step ensures Flutter bindings are ready before loading the app
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SQLite FFI on desktop platforms (Windows, Linux)
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Pre-boot the SQLite engine and seed tables
  await DatabaseHelper.instance.database;

  // Check if maternal profile has already been created
  final userProfile = await DatabaseHelper.instance.getUserProfile();
  final bool hasProfile = userProfile != null;

  // Starting point of the application execution
  runApp(SafeMomsApp(hasProfile: hasProfile));
}

class SafeMomsApp extends StatelessWidget {
  final bool hasProfile;

  const SafeMomsApp({super.key, this.hasProfile = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeMoms',
      debugShowCheckedModeBanner: false, // Removes the red debug banner from your preview
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true, // Uses modern Android UI material styles
      ),
      home: hasProfile ? const DashboardScreen() : const OnboardingScreen(),
    );
  }
}
