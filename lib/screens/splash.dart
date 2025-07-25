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
    Future.delayed(const Duration(seconds: 3), () {
<<<<<<< HEAD
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
=======
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
>>>>>>> c4d31b49a23a8723e619e903aeb9061705fd6a3b
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // Light background
      body: Center(
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(seconds: 2),
<<<<<<< HEAD
          curve: Curves.easeOutBack,  // Smooth scaling effect
=======
          curve: Curves.easeOutBack,
>>>>>>> c4d31b49a23a8723e619e903aeb9061705fd6a3b
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 470, // Bigger logo height
                width: 470,  // Bigger logo width
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(150),
                  child: Image.asset(
                    'assets/images/ValuMate_logo.png',
                    fit: BoxFit.contain, // Keep full image visible
                  ),
                ),
              ),
<<<<<<< HEAD
              const SizedBox(height: 20),
              Text(
                'Valuation App',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Simplifying Property Valuations',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(color: Colors.blue),
=======
              const SizedBox(height: 30),
              const CircularProgressIndicator(
                color: Color(0xFFFFD700), // Gold color
              ),
>>>>>>> c4d31b49a23a8723e619e903aeb9061705fd6a3b
            ],
          ),
        ),
      ),
    );
  }
}
