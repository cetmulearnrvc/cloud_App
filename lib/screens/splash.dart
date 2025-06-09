import 'package:flutter/material.dart';
import 'package:login_screen/main.dart';
import 'package:login_screen/screens/home.dart';
import 'package:login_screen/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    UserLoggedIn();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(child: Image.asset('assets/images/splash.jpeg')),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> goToLogin() async{

  await Future.delayed(const Duration(seconds: 3));
  Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
    return LoginScreen();
  }));
}

Future<void> UserLoggedIn() async{

  final sharedPrefs= await SharedPreferences.getInstance();
  final userValue = sharedPrefs.getBool(key_value);

  if(userValue == true)
  {
    // build(context);
    // await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
      return HomeScreen();
    }));
  }

  else{
    goToLogin();
  }
}
}

