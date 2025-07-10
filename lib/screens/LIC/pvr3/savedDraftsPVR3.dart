import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:login_screen/screens/LIC/pvr3/valuation_form_screen.dart';
import 'dart:convert';
import 'config.dart';

class SavedDraftsPVR3 extends StatefulWidget {
  const SavedDraftsPVR3({super.key});

  @override
  State<SavedDraftsPVR3> createState() => _SavedDraftsPVR3State();
}

class _SavedDraftsPVR3State extends State<SavedDraftsPVR3> {
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
      debugPrint(formattedDate);
      final response = await http.post(
        Uri.parse(url3), // Adjust endpoint for PVR3
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
        builder: (context) => ValuationFormScreen(
          propertyData: propertyData, // Pass data to PVR3 form
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PVR3 Drafts'),
        backgroundColor: Colors.green, // PVR3 theme color
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
                backgroundColor: Colors.green, // PVR3 theme color
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
                        title: Text('File No: ${property['fileNo'] ?? 'N/A'}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Applicant: ${property['applicantName'] ?? 'N/A'}'),
                            const SizedBox(height: 4),
                            Text(
                              'Property Type: ${property['propertyType'] ?? 'N/A'}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Address: ${property['address'] ?? 'N/A'}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Inspection Date: ${property['inspectionDate'] ?? 'N/A'}',
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
                  child: Text('No PVR3 drafts found'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
