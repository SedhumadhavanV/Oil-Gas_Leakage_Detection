
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gasleakage/widgets/auth_gate.dart';
import 'dart:async';

import 'intro.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 5 seconds and then navigate to intro
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthGate()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/gl.jpg'), // Replace with your image asset
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Fading Container with Background Color
          Container(
            color: Colors.black54, // Set your desired background color here
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Gas Leakage Monitoring',
                    style: TextStyle(
                      fontSize: 35.0, // Set your desired font size
                      fontWeight: FontWeight.bold, // Set your desired font weight
                      color: Colors.white70, // Set your desired text color
                    ),
                  ),
                  SizedBox(height: 20.0), // Add some space between text and spinner
                  SpinKitCircle(
                    // Loading spinner
                    color: Colors.red,
                    size: 80.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
