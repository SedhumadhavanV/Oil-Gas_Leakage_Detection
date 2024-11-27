import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class OilLevelMonitoring extends StatefulWidget {
  @override
  _OilLevelMonitoringState createState() => _OilLevelMonitoringState();
}

class _OilLevelMonitoringState extends State<OilLevelMonitoring> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _currentOilLevel = 0.0; // Default value

  // Reference to your Firebase Realtime Database
  final _database = FirebaseDatabase.instance.reference().child('oillevel');

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0, // Change this to 1.0 (100%)
    ).animate(_animationController);

    // Start animation
    _animationController.forward();

    // Listen to changes in the database
    _database
        .child('value')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        final dynamic data = event.snapshot.value;
        if (data is Map && data.containsKey('oil')) {
          setState(() {
            _currentOilLevel = double.parse(data['oil'].toString());
            _animationController.animateTo(_currentOilLevel /
                100); // Adjust animation based on oil level percentage
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Oil Level Monitoring'),
        backgroundColor: Colors.blueGrey[900],
      ),
      backgroundColor: Colors.white70,
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Oil Tank with percentage
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      height: 200,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return Container(
                                height: 150 * _animation.value,
                                width: double.infinity,
                                color: Colors.amber,
                                child: Center(
                                  child: Text(
                                    '${_currentOilLevel.toStringAsFixed(2)}cm',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 20,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10),
                // Display the oil percentage
                Text(
                  '${_currentOilLevel.toStringAsFixed(2)}cm',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Oil Level Display
            Text(
              'Current Oil Level',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: _currentOilLevel / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
            ),
          ],
        ),
      ),
    );
  }
}