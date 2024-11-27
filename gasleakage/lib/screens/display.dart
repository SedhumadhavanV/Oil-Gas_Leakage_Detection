import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(rr());
}

class rr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          // An empty app bar to give more space for the snack bar at the top
          toolbarHeight: 0,
        ),
        body: display(),
      ),
    );
  }
}

class display extends StatefulWidget {
  const display({super.key});

  @override
  State<display> createState() => _UserRequestState();
}

class HealthData {
  final String heartrate;
  final String bottlevalue;
  final String temperature;

  HealthData(this.heartrate, this.bottlevalue, this.temperature);
}

class _UserRequestState extends State<display> {
  String authh = " ";
  int finalvalue = 100;
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.reference().child('monitoring');

  @override
  void initState() {
    super.initState();

    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    String? userId = user?.uid;

    if (userId != null) {
      setState(() {
        authh = userId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _buildListViewWithDivider(),
    );
  }

  Widget _buildListViewWithDivider() {
    return Center(
      child: StreamBuilder(
        stream: _databaseReference
            .orderByChild('status')
            .equalTo('accept')
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading requests.'),
            );
          } else
          if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
            return Center(
              child: Text('No Requests.'),
            );
          } else {
            Map<String, dynamic> data =
            Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);

            List<String> itemIds = data.keys.toList();

            // Check for bottle value and show pop-up
            for (String itemId in itemIds) {





              // if (temperature > finalvalue) {
              //   _showPopUpSnackBar();
              //   break; // Only show pop-up once if multiple items have 100% value
              // }
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 200),
                Image.asset(
                  'assets/images/gasleak.gif',
                  width: 150.0,
                  height: 150.0,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 140),
                Expanded( // Wrap ListView.builder with Expanded
                  child: ListView.builder(
                    itemCount: itemIds.length * 2 - 1,
                    itemBuilder: (context, index) {
                      if (index.isOdd) {
                        return Divider();
                      } else {
                        int itemIndex = index ~/ 2;
                        String itemId = itemIds[itemIndex];
                        String heartrate = data[itemId]['methane']?.toString() ?? '';
                        String bottlevalue = data[itemId]['lpg']?.toString() ?? '';
                        // String temperature = data[itemId]['temperature']?.toString() ?? '';
String temperature="353";
                        return _buildListItem(
                          heartrate: heartrate,
                          bottlevalue: bottlevalue,
                          temperature: temperature,
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
  Widget _buildListItem({
    required String heartrate,
    required String bottlevalue,
    required String temperature,
  }) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white60,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: _buildCard(
              label: 'Methane',
              value: '$heartrate',
              color: Colors.redAccent,
            ),
          ),
          SizedBox(width: 20.0),
          Expanded(
            child: _buildCard(
              label: 'LPG' ,
              value: '$bottlevalue',
              color: Colors.indigo,
            ),
          ),
          // SizedBox(width: 20.0),
          // Expanded(
          //   child: _buildCard(
          //     label: 'Temperature',
          //     value: '$temperature \u2103',
          //     color: Colors.redAccent,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      color: color,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: EdgeInsets.all(16.0),
        width: 150.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPopUpSnackBar() {
    Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning,
                color: Colors.white,
                size: 24.0,
              ),
              SizedBox(width: 8.0),
              Text(
                'Bottle Drained, Please Change...',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.fixed, // Show at the top
          backgroundColor: Colors.red,
          elevation: 4.0,
        ),
      );

      // Show the second snack bar after 10 seconds
      Future.delayed(Duration(seconds: 10), () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 24.0,
                ),
                SizedBox(width: 8.0),
                Text(
                  'Management Monitoring Nurse',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            behavior: SnackBarBehavior.fixed, // Show at the top
            backgroundColor: Colors.green,
            elevation: 4.0,
          ),
        );
      });
    });
  }
}