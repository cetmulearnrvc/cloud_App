import 'package:flutter/material.dart';
import 'package:login_screen/screens/splash.dart';

const key_value='UserLoggedIn';
main()
{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      title: 'Login',
      home : SplashScreen()
    );
  }
}