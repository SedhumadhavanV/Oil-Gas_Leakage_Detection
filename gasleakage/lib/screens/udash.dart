import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'maindash.dart';






void main() {
  runApp(new MaterialApp(
    home: new udash(),



  ));




}
/*class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Text("Tutor joes")






    );
  }
}*/
class udash extends StatefulWidget {
  const udash({super.key});

  @override
  State<udash> createState() => _MyAppState();
}

class _MyAppState extends State<udash> {
/*
String value='Text';
void Clickme(){

setState(() {
value='tutor';


});


}
*/

  int _currentIndex = 0;
  final List<Widget> _pages = [

    Dashboard()

  ];

  var islogoutloading=false;

  logout() async{
    setState(() {
      islogoutloading=true;

    });

    await FirebaseAuth.instance.signOut();

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  LoginView(

    ),));






    setState(() {
      islogoutloading=false;

    });


  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Welcome'),
        actions: [
          // Your application button
          // TextButton(
          //   onPressed: () {
          //     // Handle button press
          //     // Replace the following line with the action you want to perform
          //     Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(builder: (context) => apply()),
          //     );
          //   },
          //   child: Text(
          //     'Apply',
          //     style: TextStyle(
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
          IconButton(
            onPressed: () {
              logout();
            },
            icon: islogoutloading
                ? CircularProgressIndicator()
                : Icon(Icons.exit_to_app, color: Colors.red),
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_from_queue_outlined),
            label: 'Rescue team ',
          ),


        ],
        selectedItemColor: Colors.indigo, // Customize the selected item color
        unselectedItemColor: Colors.grey, // Customize the unselected item color
        backgroundColor: Colors.white, // Customize the background color
        elevation: 10, // Add elevation to the bar
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold), // Customize the selected label style
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal), // Customize the unselected label style
      ),
    );
  }
}