import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
void main()  {
 // The absolute starting point of your application execution thread on the phone
  runApp(const SafeMomsApp());
}

class SafeMomsApp extends StatelessWidget {
  const SafeMomsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeMoms',
      debugShowCheckedModeBanner: false, // Removes the red debug banner from your preview
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true, // Uses modern Android UI material styles
      ),
      // Tells Flutter to open up your onboarding setup form immediately on boot
      home: const OnboardingScreen(), 
    );
  }
}
