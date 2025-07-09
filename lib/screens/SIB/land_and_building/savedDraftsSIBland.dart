import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:login_screen/screens/SIB/land_and_building/land_and_building.dart';
import 'dart:convert';
import 'config.dart';

class SavedDraftsSIBLand extends StatefulWidget {
  const SavedDraftsSIBLand({super.key});

  @override
  State<SavedDraftsSIBLand> createState() => _SavedDraftsSIBLandState();
}

class _SavedDraftsSIBLandState extends State<SavedDraftsSIBLand> {
  DateTime date = DateTime.now();
  List<dynamic> searchResults = [];
  bool isLoading = false;

  Future<void> searchByDate() async {
    setState(() {
      isLoading = true;
      searchResults = [];
    });

    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final response = await http.post(
        Uri.parse('$url3'), // Adjust endpoint for SIB Land
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'date': formattedDate}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          searchResults = data;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateToValuationForm(Map<String, dynamic> propertyData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ValuationFormPage(
          propertyData: propertyData, // Pass data to SIB Land form
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIB Land Drafts'),
        backgroundColor: Colors.blue, // Different color for SIB
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Select Date'),
              subtitle: Text(DateFormat('dd-MM-yyyy').format(date)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2200),
                );
                if (picked != null) {
                  setState(() {
                    date = picked;
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: isLoading ? null : searchByDate,
              label: const Text('Search'),
              icon: const Icon(Icons.search),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // SIB theme color
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (searchResults.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final property = searchResults[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text('Ref ID: ${property['refId'] ?? 'N/A'}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Bank: State Bank Of India-Land'), // Always shows Federal Bank
                            const SizedBox(height: 4),
                            Text('Owner: ${property['ownerName'] ?? 'N/A'}'),
                            const SizedBox(height: 4),
                            Text(
                                'Applicant: ${property['applicantName'] ?? 'N/A'}'),
                            const SizedBox(height: 4),
                            Text(
                              'Location: ${property['addressActual'] ?? property['addressDocument'] ?? 'N/A'}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),

                            Text(
                              'InspectionDate: ${property['dateOfInspection'] ?? 'N/A'}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () => navigateToValuationForm(property),
                      ),
                    );
                  },
                ),
              )
            else if (!isLoading)
              const Expanded(
                child: Center(
                  child: Text('No SIB Land drafts found'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
