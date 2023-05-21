import 'package:flutter/material.dart';

import 'models/user_model.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';

class Routes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => SignupScreen());
      // case home:
      //   UserModel user = settings.arguments as UserModel;
      // return MaterialPageRoute(
      //   builder: (_) => HomePage(user: user),
      // );
      default:
        return MaterialPageRoute(builder: (_) => Scaffold(
          body: Center(
            child: Text('Error: Route not found!'),
          ),
        ));
    }
  }
}
