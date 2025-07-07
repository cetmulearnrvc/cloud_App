import 'package:flutter/material.dart';
import 'package:login_screen/screens/loanType.dart';
import 'package:login_screen/screens/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore_for_file: prefer_const_constructors
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> banks = [
    {
      'name': 'Canara Bank',
      'icon': 'assets/images/canara.jpeg',
    },
    {
      'name': 'IDBI Bank',
      'icon': 'assets/images/idbi.jpeg',
    },
    {
      'name': 'LIC',
      'icon': 'assets/images/lic.jpeg',
    },
    {
      'name': 'Federal Bank',
      'icon': 'assets/images/federal.jpeg',
    },
    {
      'name': 'South Indian Bank',
      'icon': 'assets/images/south indian.jpeg',
    },
  ];

  Map<String, dynamic>? selectedData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('HOME SCREEN', style: TextStyle(fontWeight: FontWeight.bold)),
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
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'SELECT A BANK',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25,decoration: TextDecoration.underline),
                  
                ),
                const SizedBox(height: 15),
                Image.asset('assets/images/bank.png'),
                const SizedBox(height: 15),
                DropdownButtonFormField<Map<String, dynamic>>(
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  hint: Text('Select a Bank'),
                  value: selectedData,  // ✅ Fix: Set current value
                  items: banks.map((e) {
                    return DropdownMenuItem<Map<String, dynamic>>(
                      value: e,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e['name']),
                          Image.asset(
                            e['icon'],
                            height: 50,
                            width: 50,
                          )
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedData = value;  // ✅ Fix: Update state
                    });
                    if (selectedData != null) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => LoanType(selectedBank: selectedData)));
                    }
                  },
                ),
              ],
            ),
          )),
        ));
  }

  signout(BuildContext ctx) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.clear();

    Navigator.of(ctx).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx1) {
      return SplashScreen();
    }), (route) => false);
  }
}
