// import 'package:flutter/material.dart';

// // ignore_for_file: prefer_const_constructors
// class LoginScreen extends StatelessWidget {
//   LoginScreen({super.key});

//   final _userController = TextEditingController();
//   final _passwdController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Login Screen'),
//               TextFormField(
//                 controller: _userController,
//                 decoration: InputDecoration(
//                     border: OutlineInputBorder(), hintText: 'Username'),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               TextFormField(
//                 controller: _passwdController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                     border: OutlineInputBorder(), hintText: 'Password'),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               ElevatedButton.icon(
//                   onPressed: () {
//                     checkLogin(context);
//                   },
//                   icon: Icon(Icons.check_box),
//                   label: Text('login'))
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void checkLogin(BuildContext ctx) {
//     final _username = _userController.text;
//     final _passwd = _passwdController.text;
//     if (_username == _passwd) {
//       // Go to home
//     } else {
//       final msg = 'Username and passwd do not match';
//       //SnackBar
//       ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(msg),
//       behavior: SnackBarBehavior.floating,
//       margin: EdgeInsets.all(10),
//       duration: Duration(seconds: 10),
//       backgroundColor: Colors.blue,));

//       //Alert Dialog
//       showDialog(context: ctx, builder: (ctx1){
//          return AlertDialog(
//           title: Text('Error'),
//           content: Text(msg),
//           actions: [
//             TextButton(onPressed: (){
//               Navigator.of(ctx1).pop();
//             }, child: Text('Close'))
//           ],
//          );
//       });
//       //Show Text
//     }
//   }
// }
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:login_screen/main.dart';
import 'package:login_screen/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _usernameController = TextEditingController();
  final _passwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                helperText: 'Alphabets,numbers,underscore allowed',
                iconColor: Colors.blue,
                // icon: IconButton(onPressed: (){}, icon: Icon(Icons.check_circle_outline_rounded)),
                border: OutlineInputBorder(),
                hintText: 'Username',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _passwdController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(
                onPressed: () {
                  LoginCheck(context);
                },
                icon: Icon(Icons.check),
                label: Text('Login'))
          ],
        ),
      )),
    );
  }

  void LoginCheck(BuildContext ctx) async{
    final username = _usernameController.text;
    final passwd = _passwdController.text;
    final String msg = 'Username and password do not match';
    if (username == passwd) {

      final _sharedPrefs= await SharedPreferences.getInstance();
      final _value= _sharedPrefs.setBool(key_value, true);

      Navigator.of(ctx).pushReplacement(MaterialPageRoute(builder: (ctx1){
        return HomeScreen();
      }));
    } 
    
    else {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.blue,
      ));

      //Alert Dialog

      showDialog(context: ctx, builder: (ctx1){
        return AlertDialog(title: Text('Error'),
        content: Text(msg),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(ctx1).pop();
          }, child: Text('Close'))
        ],
        
        );
      });


      
    }
  }
}
