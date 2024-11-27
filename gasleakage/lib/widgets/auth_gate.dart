import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/login_screen.dart';
import '../screens/maindash.dart';
import '../screens/udash.dart';





void main() {
  runApp(new MaterialApp(
    home: new AuthGate(),



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
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

/*
String value='Text';
void Clickme(){

setState(() {
value='tutor';


});


}
*/
  @override
  Widget build(BuildContext context) {
   return StreamBuilder<User?>(stream: FirebaseAuth.instance.authStateChanges(),
       builder: (context,snapshot){
if(!snapshot.hasData) {
  return LoginView();

}
     return Dashboard();
       }

    );

  }
}








