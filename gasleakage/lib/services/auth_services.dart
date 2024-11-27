import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/login_screen.dart';

import '../screens/maindash.dart';
import '../screens/udash.dart';





class AuthService{
createuser(data, context) async {
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: data['email'],
      password:data['password'] ,
    );
    sendVerificationEmail();

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  LoginView(),));

  } catch (e) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("Sign Up Failed"),
        content: Text(e.toString()),

      );
    });
  }









  }
//
// createdonoruser(data, context) async {
//   try {
//     print("lllllllllll");
//     final credential = await FirebaseAuth.instance
//         .createUserWithEmailAndPassword(
//       email: data['email'],
//       password: data['password'],
//
//     );
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Registered Successfully')),
//
//     );
//     sendVerificationEmail();
//     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  rlogin(),));
//
//
//
//   } catch (e) {
//     showDialog(context: context, builder: (context) {
//       return AlertDialog(
//         title: Text("Sign Up Failed"),
//         content: Text(e.toString()),
//
//       );
//     });
//   }
// }

  login(data, context) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload();
        user = FirebaseAuth.instance.currentUser;
        if (user!.emailVerified) {
          print("User is verified. Proceed with login.");
          // Perform the actions for a logged-in verified user.

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login  Successfully')),

          );

          Navigator.pushReplacement(
              context as BuildContext, MaterialPageRoute(builder: (context) => Dashboard(),));

        } else {
          showDialog(context: context, builder: (context) {
            return AlertDialog(
              title: Text("Email not verified"),
              content: Text("Please Verify Your Email"),

            );
          });



          print("User is not verified. Please check your email for the verification link.");


        }
      }





    } catch (e) {
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: Text("Login Error"),
          content: Text(e.toString()),

        );
      });
    }
  }



//
// logindonor(data, context) async {
//   try {
//     final credential = await FirebaseAuth.instance
//         .signInWithEmailAndPassword(
//       email: data['email'],
//       password: data['password'],
//     );
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       await user.reload();
//       user = FirebaseAuth.instance.currentUser;
//       if (user!.emailVerified) {
//         print("User is verified. Proceed with login.");
//         // Perform the actions for a logged-in verified user.
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Login  Successfully')),
//
//         );
//
//         Navigator.pushReplacement(
//             context as BuildContext, MaterialPageRoute(builder: (context) => welres(),));
//
//       } else {
//         showDialog(context: context, builder: (context) {
//           return AlertDialog(
//             title: Text("Email not verified"),
//             content: Text("Please Verify Your Email"),
//
//           );
//         });
//
//
//
//         print("User is not verified. Please check your email for the verification link.");
//
//
//       }
//     }
//
//
//
//
//
//   } catch (e) {
//     showDialog(context: context, builder: (context) {
//       return AlertDialog(
//         title: Text("Login Error"),
//         content: Text(e.toString()),
//
//       );
//     });
//   }
// }
Future<void> sendVerificationEmail() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null && !user.emailVerified) {
    await user.sendEmailVerification();



    print("Verification email sent to ${user.email}");
  }
}









}









