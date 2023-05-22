import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_canteen/routes.dart';
import 'package:food_canteen/screens/cart_screen.dart';
import 'package:food_canteen/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'models/user_model.dart';
import 'screens/login_screen.dart';

void main() async{
WidgetsFlutterBinding.ensureInitialized();
 SharedPreferences prefs = await SharedPreferences.getInstance();
bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
UserModel user=UserModel(email: '', name: '', uid: '');
  if (isLoggedIn) {
    String? userJson = prefs.getString('user');
    Map<String, dynamic> userMap = jsonDecode(userJson!);
    user = UserModel(
      name: userMap['name'],
      uid: userMap['uid'],
      email: userMap['email'],
      // Set other properties accordingly
    );
  }

await Firebase.initializeApp();
// final fcmToken = await FirebaseMessaging.instance.getToken();
// print(fcmToken);
runApp( 
  ChangeNotifierProvider(
      create: (_) => CartProvider(),child:MyApp(isLoggedIn: isLoggedIn ,user: user)));
}
 
class MyApp extends StatefulWidget {
  final bool isLoggedIn;
    final UserModel user;
  MyApp({required this.isLoggedIn, required  this.user}) ;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
// final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
// @override
// void initState() {
//   super.initState();
//   _firebaseMessaging.getToken().then((token) => print(token));
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//   print("onMessage: $message");
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       content: ListTile(
//         title: Text(message.notification!.title ?? ''),
//         subtitle: Text(message.notification!.body ?? ''),
//       ),
//       actions: <Widget>[
//         TextButton(
//           child: const Text('Ok'),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ],
//     ),
//   );
// });
// _firebaseMessaging.getNotificationSettings().then((settings) {
//   print('User granted permission: ${settings.authorizationStatus}');
// });
// }

@override
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'Food Masti',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.orange,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(
            fontSize: 24.0,
          ),
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        ),
      ),
      textTheme: TextTheme(
        headline1: TextStyle(
          fontSize: 46.0,
          color: const Color.fromARGB(255, 210, 133, 25),
          fontWeight: FontWeight.w500,
        ),
        bodyText1: const TextStyle(fontSize: 18.0),
      ),
    ),
     home: widget.isLoggedIn ? HomePage(user: widget.user) : LoginScreen(),
  );
}
}