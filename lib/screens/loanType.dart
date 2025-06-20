import 'package:flutter/material.dart';
import 'package:login_screen/screens/LIC/pvr1/valuation_form_screen_pvr1.dart';
import 'package:login_screen/screens/LIC/pvr3/valuation_form_screen.dart';
import 'package:login_screen/screens/location.dart';
import 'package:login_screen/screens/federal.dart';

//ignore_for_file:prefer_const_constructors
class LoanType extends StatelessWidget {
  final selectedBank;

  const LoanType({super.key, required this.selectedBank});
  // const LoanType({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget bankName;
    if (selectedBank['name'] == 'Canara Bank') {
      bankName = Canara(context);
    } else if (selectedBank['name'] == 'IDBI Bank') {
      bankName = IDBI(context);
    } else if (selectedBank['name'] == 'LIC') {
      bankName = LIC(context);
    } else if (selectedBank['name'] == 'South Indian Bank') {
      bankName = SIB(context);
    } else {
      bankName = Federal(context);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Select Loan Type'),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
          child: Center(
        child: bankName,
      )),
    );
  }

  Widget LIC(BuildContext ctx) {
    final List<Map<String, String>> loanTypes = [
      {'title': 'HOUSE CONSTRUCTION'},
      {'title': 'HOUSE RENOVATION'},
    ];

    return Column(
      children: [
        Text('LIC',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                decoration: TextDecoration.underline)),
        SizedBox(
          height: 100,
        ),
        DropdownButtonFormField(
            decoration: InputDecoration(border: OutlineInputBorder()),
            hint: Text('Select the valuation type'),
            isExpanded: true,
            items: loanTypes.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Text(e['title']!),
              );
            }).toList(),
            onChanged: (value) {
              print(value?['title']);
              if(value?['title']=='HOUSE RENOVATION')
              {
                Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx1) {
                return ValuationFormScreen();
              }));
              }
              else
              {
                Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx1) {
                return ValuationFormScreenPVR1();
              }));
              }
            }),
      ],
    );
  }

  Widget IDBI(BuildContext ctx) {
    final List<Map<String, String>> loanTypes = [
      {'title': 'HOUSE CONSTRUCTION'},
      {'title': 'HOUSE RENOVATION'},
    ];

    return Column(
      children: [
        Text('IDBI Bank',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                decoration: TextDecoration.underline)),
        SizedBox(
          height: 100,
        ),
        DropdownButtonFormField(
            decoration: InputDecoration(border: OutlineInputBorder()),
            hint: Text('Select the valuation type'),
            isExpanded: true,
            items: loanTypes.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Text(e['title']!),
              );
            }).toList(),
            onChanged: (value) {
              Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx1) {
                return LocationScreen();
              }));
            }),
      ],
    );
  }

  Widget Federal(BuildContext ctx) {
    final List<Map<String, String>> loanTypes = [
      {'title': 'LAND AND BUILDING'},
    ];

    return Column(
      children: [
        Text('Federal Bank',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                decoration: TextDecoration.underline)),
        SizedBox(
          height: 100,
        ),
        DropdownButtonFormField(
            decoration: InputDecoration(border: OutlineInputBorder()),
            hint: Text('Select the valuation type'),
            isExpanded: true,
            items: loanTypes.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Text(e['title']!),
              );
            }).toList(),
            onChanged: (value) {
              Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx1) {
                return PdfGeneratorScreen();
              }));
            }),
      ],
    );
  }

  Widget Canara(BuildContext ctx) {
    final List<Map<String, String>> loanTypes = [
      {'title': 'Plant And Machinery'},
      {'title': 'Property (Land & BUILDING)'},
      {
        'title':
            'VALUATION OF COMMERCIAL BUILDING BY RENT CAPITALISATION METHOD'
      },
      {'title': 'VALUATION OF FLAT BY COMPOSITE RATE METHOD'},
      {'title': 'GENERAL FORMAT VALUATION REPORT OTHER PROPERTIES'},
      {
        'title':
            'VALUATION OF VACANT SITES/ RESIDENTIAL PLOT / COMMERCIAL SITE / LAND'
      },
      {'title': 'VALUATION REPORT (IN RESPECT OF AGRICULTURAL LANDS)'},
    ];

    return Column(
      children: [
        Text('Canara Bank',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                decoration: TextDecoration.underline)),
        SizedBox(
          height: 100,
        ),
        DropdownButtonFormField(
            decoration: InputDecoration(border: OutlineInputBorder()),
            hint: Text('Select the valuation type'),
            isExpanded: true,
            items: loanTypes.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Text(e['title']!),
              );
            }).toList(),
            onChanged: (value) {
              Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx1) {
                return LocationScreen();
              }));
            }),
      ],
    );
  }

  Widget SIB(BuildContext ctx) {
    final List<Map<String, String>> loanTypes = [
      {'title': 'VALUATION REPORT (IN RESPECT OF LAND / SITE AND BUILDING)'},
      {'title': 'VALUATION REPORT (IN RESPECT OF FLATS)'},
      {'title': 'VALUATION REPORT (IN RESPECT OF VACANT LAND / SITE)'},
    ];

    return Column(
      children: [
        Text('South Indian Bank',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                decoration: TextDecoration.underline)),
        SizedBox(
          height: 100,
        ),
        DropdownButtonFormField(
            decoration: InputDecoration(border: OutlineInputBorder()),
            hint: Text('Select the valuation type'),
            isExpanded: true,
            items: loanTypes.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Text(e['title']!),
              );
            }).toList(),
            onChanged: (value) {
              Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx1) {
                return LocationScreen();
              }));
            }),
      ],
    );
  }
}
