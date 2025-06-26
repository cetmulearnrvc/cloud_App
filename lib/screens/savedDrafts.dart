import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SavedDrafts extends StatefulWidget {
   SavedDrafts({super.key});

  @override
  State<SavedDrafts> createState() => _SavedDraftsState();
}

class _SavedDraftsState extends State<SavedDrafts> {
    DateTime date=DateTime(2025,06,26);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Saved Drafts'),backgroundColor: Colors.green,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Select Date'),
              subtitle: Text(DateFormat('dd-MM-yyyy').format(date)),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                final _picked= await showDatePicker(context: context,initialDate: date, firstDate: DateTime(2000), lastDate: DateTime(2200));
                if(_picked != null)
                {
                  setState(() {
                    date=_picked;
                  });
                }
              },
            ),
            SizedBox(height: 10,),
            ElevatedButton.icon(onPressed: (){}, label: Text('Search'),icon: Icon(Icons.search),)
          ],
        ),
      )
    );
  }
}