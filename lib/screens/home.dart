import 'package:flutter/material.dart';
import 'package:login_screen/screens/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore_for_file: prefer_const_constructors
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              signout(context);
            },
            icon: Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: SafeArea(
          child: Center(
        child: ListView.separated(itemBuilder: ((context, index) {
          return Column(
            children: [
              Text('Select Bank',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
              
              IconButton(onPressed: (){}, icon: Image.asset('assets/images/canara.jpeg',height: 200,width: 200,)),
              IconButton(onPressed: (){}, icon: Image.asset('assets/images/idbi.jpeg',height: 200,width: 200,)),
              IconButton(onPressed: (){}, icon: Image.asset('assets/images/lic.jpeg',height: 200,width: 200,)),

                        ],
          );
        }), separatorBuilder: ((context, index) {
          return Divider();
        }), itemCount: 1)
        ),
      ));
    
  }

  signout(BuildContext ctx) async {
    final _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs.clear();

    Navigator.of(ctx).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx1) {
      return SplashScreen();
    }), (route) => false);
  }
}
