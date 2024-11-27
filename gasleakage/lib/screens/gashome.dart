import 'dart:async'; // Import the dart:async library to use Timer

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

void main() {
  runApp(MaterialApp(
    home: GasLeakageHome(),
  ));
}

class GasLeakageHome extends StatefulWidget {
  @override
  _GasLeakageHomeState createState() => _GasLeakageHomeState();
}

class _GasLeakageHomeState extends State<GasLeakageHome> {
  DatabaseReference _databaseReference =
  FirebaseDatabase.instance.reference();

  String _data = ''; // Variable to store fetched data
  final _database = FirebaseDatabase.instance.reference().child('Alert');

  @override
  void initState() {
    super.initState();
    fetchDataFromDatabase();
  }

  void fetchDataFromDatabase() {
    _database.child('value').onValue.listen((event) {
      if (event.snapshot.value != null) {
        final dynamic data = event.snapshot.value;
        if (data is Map &&
            data.containsKey('status') &&
            data.containsKey('message') &&
            data['status'] == 'accept') {
          print('Status: ${data['status']}'); // Print status data
          print('Message: ${data['message']}'); // Print message data

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Alert'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10),
                    // Blinking red text
                    BlinkingText(
                      text: 'Message: ${data['message']}',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      update();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    });
  }

  void update() {
    // Update data in the Realtime Database for the specified udkey
    _database.child('value').update({
      "status": 'request',
      // Add other fields you want to update
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/hh.jpg', // Replace with your background image asset path
            width: 70,
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 510,
                ),
                Text(
                  'Gas Leakage Monitoring',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                SizedBox(height: 20),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BlinkingText extends StatefulWidget {
  final String text;
  final TextStyle style;
  const BlinkingText({Key? key, required this.text, required this.style})
      : super(key: key);

  @override
  _BlinkingTextState createState() => _BlinkingTextState();
}

class _BlinkingTextState extends State<BlinkingText> {
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    // Toggle the visibility of the text every 500 milliseconds
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        _visible = !_visible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 300),
      child: Text(widget.text, style: widget.style),
    );
  }
}
