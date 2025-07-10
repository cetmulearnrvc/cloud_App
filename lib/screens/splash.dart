import 'package:flutter/material.dart';
import 'package:login_screen/screens/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: Colors.black,  // Premium dark background
  body: Center(
    child: TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(seconds: 2),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(
              'assets/images/AppLogo.jpg',  // Your new logo
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20),
          
          CircularProgressIndicator(color: Color(0xFFFFD700)),  // Gold progress
        ],
      ),
    ),
  ),
);

  }
}
