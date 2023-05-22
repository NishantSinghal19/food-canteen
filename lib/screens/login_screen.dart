// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_canteen/models/user_model.dart';
import 'package:food_canteen/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';

import '../routes.dart';
import '../services/auth_methods.dart';
import '../utils/utils.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  // static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailIdController =  TextEditingController();
  final TextEditingController _passwordController =  TextEditingController();
  bool _isLoading = false;

  var _textStyleBlack =  TextStyle(fontSize: 12.0, color: Colors.black);
  var _textStyleGrey =  TextStyle(fontSize: 12.0, color: Colors.grey);
  var _textStyleBlueGrey =
       TextStyle(fontSize: 12.0, color: Colors.blueGrey);

  @override
  void dispose() {
    super.dispose();
    _emailIdController.dispose();
    _passwordController.dispose();
  }

  Future<bool> _logInUser() async {
    if (_emailIdController.text.isEmpty || _passwordController.text.isEmpty) {
      _showEmptyDialog("Please enter email and password");
      return false;
    }

    setState(() {
      _isLoading = true;
    });

    // Call the login method and get the user details
    UserModel? user = await AuthMethod().logInUser(
      email: _emailIdController.text,
      password: _passwordController.text,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('user', jsonEncode(user?.toJson()));
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(user: user),
        ),
      );
    } else {
      showSnackBar("Invalid email or password", context);
    }

    setState(() {
      _isLoading = false;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      bottomNavigationBar: _bottomBar(),
      body: _body(),
    );
  }

  Widget _userIDEditContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child:  TextField(
        controller: _emailIdController,
        decoration:  InputDecoration(
            hintText: 'Email',
            border:  OutlineInputBorder(
              borderSide:  BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10.0),

            ),
            isDense: true),
        style: _textStyleBlack,
      ),
    );
  }

  Widget _passwordEditContainer() {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: TextField(
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Password',
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10.0),
            ),
            isDense: true),
        style: _textStyleBlack,
      ),
    );
  }

  Widget _loginContainer() {
    return GestureDetector(
      onTap: _logInUser,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.orangeAccent,
        ),
        margin: EdgeInsets.only(top: 10.0),
        width: 500.0,
        height: 40.0,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Text(
                "Log In",
                style: TextStyle(color: Colors.white),
              ),
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      alignment: Alignment.center,
      height: 49.5,
      child: Column(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 1.0,
                color: Colors.grey.withOpacity(0.7),
              ),
              Padding(
                  padding: EdgeInsets.only(bottom: 0.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Don\'t have an account?', style: _textStyleGrey),
                      Container(
                        child: TextButton(
                          onPressed: () => Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return SignupScreen();
                          })),
                          child: Text('Sign Up.', style: TextStyle(color: Color.fromARGB(255, 225, 136, 2), fontSize: 12.0)),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 25.0, bottom: 15.0),
            child: Text(
              'Food Masti',
              style: TextStyle(fontSize: 50.0),
            ),
          ),
          _userIDEditContainer(),
          _passwordEditContainer(),
          _loginContainer(),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     Text(
          //       'Forgot your login details?',
          //       style: _textStyleGrey,
          //     ),
          //     TextButton(
          //       onPressed: () {},
          //       child: Text(
          //         'Get help logging in.',
          //         style: _textStyleBlueGrey,
          //       ),
          //     )
          //   ],
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     Container(
          //       height: 1.0,
          //       width: MediaQuery.of(context).size.width / 2.7,
          //       color: Colors.grey,
          //       child: ListTile(),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  _showEmptyDialog(String title) {
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          content: Text("$title can't be empty"),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"))
          ],
        ),
      );
    } else if (Platform.isIOS) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
          content: Text("$title can't be empty"),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"))
          ],
        ),
      );
    }
  }
}

class AuthMethod {
  Future<UserModel?> logInUser(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      // Fetch additional user details from the database
      // Query Firestore or any other database to retrieve user details based on user.uid or user.email

      // Create a UserModel object with the retrieved user data
      UserModel userModel = UserModel(
        name: user!.displayName ?? 'No name',
        uid: user.uid,

        email: user.email ?? 'No email',
        // Add other relevant user details from the database
      );

      return userModel;
    } catch (error) {
      // Handle authentication errors
      print('Login failed: $error');
      return null;
    }
  }
}
