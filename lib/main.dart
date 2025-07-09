import 'package:flutter/material.dart';
import 'package:login_screen/screens/splash.dart';

const key_value='UserLoggedIn';
main()
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
  ),

  // darkTheme: ThemeData(
  //   brightness: Brightness.dark,
  //   primarySwatch: Colors.deepPurple,
  //   scaffoldBackgroundColor: Colors.black,
  // ),
  
  themeMode: ThemeMode.light,//ThemeMode.system
      title: 'Login',
      home : const SplashScreen()
    );
  }
}