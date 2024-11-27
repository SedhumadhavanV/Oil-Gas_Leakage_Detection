import 'package:flutter/material.dart';
import 'package:gasleakage/screens/sign_up.dart';
import '../services/auth_services.dart';
import '../utills/appvalidator.dart';

void main() {
  runApp(MaterialApp(
    home: LoginView(),
    theme: ThemeData(
      primaryColor: Colors.blueGrey[900],
      colorScheme: ColorScheme.dark(
        primary: Colors.blueGrey[900]!,
        secondary: Colors.orangeAccent,
      ),
      fontFamily: 'Roboto',
      textTheme: TextTheme(
        headline6: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        bodyText1: TextStyle(color: Colors.white),
        button: TextStyle(color: Colors.white, fontSize: 20),
      ),
    ),
  ));
}

class LoginView extends StatefulWidget {
  LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var isLoader = false;
  var authService = AuthService();

  Future<void> _submitForm() async {

    setState(() {
      isLoader = true;
    });

    var data = {
      "email": _emailController.text,
      "password": _passwordController.text,
    };
    await authService.login(data, context);

    setState(() {
      isLoader = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login Successfully')),
    );

  }

  var appValidator = AppValidator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container( // Wrap with Container
        width: double.infinity, // Ensure width covers entire screen
        height: double.infinity, // Ensure height covers entire screen
        child: Stack(
          children: [
            // Background Image
            Image.asset(
              'assets/images/d.jpg', // Replace 'assets/images/d.jpg' with your actual asset path
              fit: BoxFit.cover, // Ensure the image covers the entire space
              width: double.infinity, // Ensure width covers entire screen
              height: double.infinity, // Ensure height covers entire screen
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 100.0),
                      Text(
                        'User Login',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 50.0),
                      TextFormField(
                        controller: _emailController,
                        style: Theme.of(context).textTheme.bodyText1,
                        cursorColor: Colors.blue,
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: _buildInputDecoration('Email', Icons.email),
                        validator: appValidator.validateEmail,
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordController,
                        style: Theme.of(context).textTheme.bodyText1,
                        cursorColor: Colors.blue,
                        keyboardType: TextInputType.visiblePassword,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: _buildInputDecoration('Password', Icons.lock),
                      ),
                      SizedBox(height: 40.0),
                      SizedBox(
                        height: 50.0,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoader ? null : _submitForm,
                          child: isLoader
                              ? Center(child: CircularProgressIndicator())
                              : Text('Login', style: Theme.of(context).textTheme.button),
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).colorScheme.secondary,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUpView()),
                          );
                        },
                        child: Text(
                          'Create new account',
                          style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 25),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData suffixIcon) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.blueGrey[800],
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.blue),
      ),
      labelText: label,
      labelStyle: TextStyle(color: Colors.white),
      prefixIcon: Icon(suffixIcon, color: Colors.white),
    );
  }
}
