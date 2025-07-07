import 'package:flutter/material.dart';
import 'package:login_screen/screens/Federal/federal.dart';
import 'package:login_screen/screens/IDBI/valuation_form_ui.dart';
import 'package:login_screen/screens/LIC/pvr1/valuation_form_screen_pvr1.dart';
import 'package:login_screen/screens/LIC/pvr3/valuation_form_screen.dart';
import 'package:login_screen/screens/SIB/Flat/valuation_form.dart';
import 'package:login_screen/screens/location.dart';
import 'package:login_screen/screens/SIB/land_and_building/land_and_building.dart';

//ignore_for_file:prefer_const_constructors
class LoanType extends StatelessWidget {
  final selectedBank;

  const LoanType({super.key, required this.selectedBank});

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
        title: Text('SELECT VALUATION TYPE',style: TextStyle(fontWeight: FontWeight.bold),),
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
    final List<String> loanTypes = [
      '---SELECT---',
      'HOUSE CONSTRUCTION (PVR - 1)',
      'HOUSE RENOVATION (PVR - 3)',
    ];

    String? selectedValue = loanTypes[0];

    return Column(
      children: [
        Text('LIC',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                decoration: TextDecoration.underline)),
        SizedBox(height: 10,),
        Image.asset('assets/images/lic.jpeg'),
        SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: StatefulBuilder(
            builder: (context, setState) {
              return DropdownButtonFormField<String>(
                value: selectedValue,
                decoration: InputDecoration(border: OutlineInputBorder()),
                hint: Text('Select the valuation type'),
                isExpanded: true,
                items: loanTypes.map((e) {
                  return DropdownMenuItem<String>(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                  });
                  if (value == 'HOUSE RENOVATION (PVR - 3)') {
                    Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx1) {
                      return ValuationFormScreen();
                    }));
                  } else if (value == 'HOUSE CONSTRUCTION (PVR - 1)') {
                    Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx1) {
                      return ValuationFormScreenPVR1();
                    }));
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget IDBI(BuildContext ctx) {
    final List<String> loanTypes = [
      '---SELECT---',
      'VALUATION REPORT',
    ];

    String? selectedValue = loanTypes[0];

    return Column(
      children: [
        Text('IDBI Bank',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                decoration: TextDecoration.underline)),
        SizedBox(height: 10,),
        Image.asset('assets/images/idbi.jpeg'),
        SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: StatefulBuilder(
            builder: (context, setState) {
              return DropdownButtonFormField<String>(
                value: selectedValue,
                decoration: InputDecoration(border: OutlineInputBorder()),
                hint: Text('Select the valuation type'),
                isExpanded: true,
                items: loanTypes.map((e) {
                  return DropdownMenuItem<String>(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                  });
                  if (value == 'VALUATION REPORT') {
                    Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx1) {
                      return ValuationFormScreenIDBI();
                    }));
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget Federal(BuildContext ctx) {
    final List<String> loanTypes = [
      '---SELECT---',
      'LAND AND BUILDING',
    ];

    String? selectedValue = loanTypes[0];

    return Column(
      children: [
        Text('FEDERAL BANK',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                decoration: TextDecoration.underline)),
        SizedBox(height: 10,),
        Image.asset('assets/images/federal.jpeg'),
        SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: StatefulBuilder(
            builder: (context, setState) {
              return DropdownButtonFormField<String>(
                value: selectedValue,
                decoration: InputDecoration(border: OutlineInputBorder()),
                hint: Text('Select the valuation type'),
                isExpanded: true,
                items: loanTypes.map((e) {
                  return DropdownMenuItem<String>(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                  });
                  if (value == 'LAND AND BUILDING') {
                    Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx1) {
                      return PdfGeneratorScreen();
                    }));
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget Canara(BuildContext ctx) {
    final List<String> loanTypes = [
      '---SELECT---',
      'Plant And Machinery',
      'Property (Land & BUILDING)',
      'VALUATION OF COMMERCIAL BUILDING BY RENT CAPITALISATION METHOD',
      'VALUATION OF FLAT BY COMPOSITE RATE METHOD',
      'GENERAL FORMAT VALUATION REPORT OTHER PROPERTIES',
      'VALUATION OF VACANT SITES/ RESIDENTIAL PLOT / COMMERCIAL SITE / LAND',
      'VALUATION REPORT (IN RESPECT OF AGRICULTURAL LANDS)',
    ];

    String? selectedValue = loanTypes[0];

    return Column(
      children: [
        Text('CANARA BANK',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                decoration: TextDecoration.underline)),
                const SizedBox(height: 15,),
        Image.asset('assets/images/canara.jpeg'),
        SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: StatefulBuilder(
            builder: (context, setState) {
              return DropdownButtonFormField<String>(
                value: selectedValue,
                decoration: InputDecoration(border: OutlineInputBorder()),
                hint: Text('Select the valuation type'),
                isExpanded: true,
                items: loanTypes.map((e) {
                  return DropdownMenuItem<String>(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                  });
                  Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx1) {
                    return LocationScreen();
                  }));
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget SIB(BuildContext ctx) {
    final List<String> loanTypes = [
      '---SELECT---',
      'VALUATION REPORT (IN RESPECT OF LAND / SITE AND BUILDING)',
      'VALUATION REPORT (IN RESPECT OF FLATS)',
      'VALUATION REPORT (IN RESPECT OF VACANT LAND / SITE)',
    ];

    String? selectedValue = loanTypes[0];

    return Column(
      children: [
        Text('SOUTH INDIAN BANK',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                decoration: TextDecoration.underline)),
        SizedBox(height: 10,),
        Image.asset('assets/images/south indian.jpeg'),
        SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: StatefulBuilder(
            builder: (context, setState) {
              return DropdownButtonFormField<String>(
                value: selectedValue,
                decoration: InputDecoration(border: OutlineInputBorder()),
                hint: Text('Select the valuation type'),
                isExpanded: true,
                items: loanTypes.map((e) {
                  return DropdownMenuItem<String>(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                  });
                  if (value == 'VALUATION REPORT (IN RESPECT OF FLATS)') {
                    Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx1) {
                      return SIBValuationFormScreen();
                    }));
                  } else if (value ==
                      'VALUATION REPORT (IN RESPECT OF LAND / SITE AND BUILDING)') {
                    Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx1) {
                      return ValuationFormPage();
                    }));
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
