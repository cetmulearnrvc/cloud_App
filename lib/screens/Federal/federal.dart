import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart' as pdfLib;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'package:geolocator/geolocator.dart'; // Import geolocator package
// Import geolocator package

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Federal Bank',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PdfGeneratorScreen(),
    );
  }
}

class PdfGeneratorScreen extends StatefulWidget {
  const PdfGeneratorScreen({super.key});

  @override
  State<PdfGeneratorScreen> createState() => _PdfGeneratorScreenState();
}

class _PdfGeneratorScreenState extends State<PdfGeneratorScreen> {
  // New controllers for Latitude and Longitude
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lonController = TextEditingController();

  final Map<String, TextEditingController> controllers = {
    // SECTION 1: INTRODUCTION
    'Applicant Name and Branch Details': TextEditingController(),
    'Owner of the Property': TextEditingController(),
    'Name of the prospective purchaser(s)': TextEditingController(),
    'Builder Name and RERA ID': TextEditingController(),
    'Property Description': TextEditingController(),
    'Person Met on Site and his/ her relationship with the Applicant':
        TextEditingController(),
    'Property Address as per Site Visit': TextEditingController(),
    'Business Name': TextEditingController(),
    'House/ Door / Unit/ Flat/ Shop /Office / Gala No.':
        TextEditingController(),
    'Plot No.': TextEditingController(),
    'Floor': TextEditingController(),
    'Project Name/ Building Name': TextEditingController(),
    'Locality/ Sub Locality': TextEditingController(),
    'Street Name/ Road No': TextEditingController(),
    'Nearest Landmark': TextEditingController(),
    'City/ Town': TextEditingController(),
    'Village': TextEditingController(),
    'Pincode': TextEditingController(),
    'Plot No./Survey No./Khasra No.': TextEditingController(),
    'Sub-zone (upvibhag)': TextEditingController(),
    'Village_Technical': TextEditingController(),
    'Sub district (Taluka)': TextEditingController(),
    'District': TextEditingController(),
    'State': TextEditingController(),
    'Legal Address of Property': TextEditingController(),

    // SECTION 2: PROPERTY DETAILS (Existing)
    'Property Type': TextEditingController(),
    'Property Usage': TextEditingController(),
    'Permitted Usage of the Property': TextEditingController(),
    'Within Municipal Limits': TextEditingController(),
    'Municipal Number': TextEditingController(),
    'Construction Status': TextEditingController(),
    '% Complete': TextEditingController(),
    '% Recommended': TextEditingController(),
    'Type of Occupancy': TextEditingController(),
    'Tenure (if Self-Occupied)': TextEditingController(),
    'Tenure (if Vacant)': TextEditingController(),
    'If rented, Tenant Details': TextEditingController(),
    'Customer Relationship with Occupant': TextEditingController(),

    'Ownership Type': TextEditingController(),
    'Total No. of Blocks/ Buildings': TextEditingController(),
    'No. of Floors': TextEditingController(),
    'No. of Units_Total Units': TextEditingController(), // Combined for form input
    'No. of Units_Units on each Floor': TextEditingController(), // Combined for form input
    'Year Built / Age of Property (in Years)': TextEditingController(),
    'Year Built / Age of the Property (in Years)_Years': TextEditingController(), // For the 'Years' label
    'Residual Age of the Property (in Years)': TextEditingController(),
    'Maintenance Level of Building': TextEditingController(),
    'Amenities': TextEditingController(),
    'Amenities_Lifts': TextEditingController(), // For the 'Lifts' label
    'Whether the Building is constructed strictly according to Plan approved by Government authority? Give details': TextEditingController(),

    // SECTION 3: UNIT DETAILS
    'Basement': TextEditingController(),
    'Ground Floor': TextEditingController(),
    'First Floor': TextEditingController(),
    'Second Floor': TextEditingController(),
    'Third Floor': TextEditingController(),
    'Fourth Floor': TextEditingController(),
    'Fifth Floor': TextEditingController(),

    // SECTION 4: SURROUNDING LOCALITY DETAILS
    'Type of Area': TextEditingController(),
    'Classification of Area': TextEditingController(),
    'Development in Vicinity (%)': TextEditingController(),
    'Quality of Infrastructure in the Vicinity': TextEditingController(),
    'Class of Locality': TextEditingController(),
    'Nature of Locality': TextEditingController(),
    'Details of the Route through which Property can be reached': TextEditingController(),
    'Has the Property got direct and independent Access?': TextEditingController(),
    'Is the property accessible by car/ mode of accessibility available?': TextEditingController(),
    'Proximity to Civic Amenities': TextEditingController(),
    'Nearest Railway Station (Distance & Name)': TextEditingController(),
    'Nearest Hospital (Distance & Name)': TextEditingController(),
    'Nearest City Center (Distance & Name)': TextEditingController(),
    'Is this Corner Property?': TextEditingController(),
    'Property Identified Through': TextEditingController(),
    'Property Demarcated': TextEditingController(),
    'Nature of Land/ Type of Use to which it can be put': TextEditingController(),
    'If Others, Give Details': TextEditingController(),
    'General Description of Layout': TextEditingController(),
    'If Others, Give Details_2': TextEditingController(), // Renamed to avoid key conflict
    'Other Developments on the Property excluding Building, if any': TextEditingController(),
    'Approach Road Details': TextEditingController(),
    'Approach Road Details_Width': TextEditingController(), // For the width

    'Marketability': TextEditingController(),
    'Encroachment Details, if any': TextEditingController(),
    'Is the Property Prone to any Disaster?': TextEditingController(),
    'Any Locational Advantages Noted': TextEditingController(),

    // SECTION 5: PHYSICAL DETAILS
    'Boundaries_North_SiteVisit': TextEditingController(),
    'Boundaries_North_LegalDocuments': TextEditingController(),
    'Boundaries_South_SiteVisit': TextEditingController(),
    'Boundaries_South_LegalDocuments': TextEditingController(),
    'Boundaries_East_SiteVisit': TextEditingController(),
    'Boundaries_East_LegalDocuments': TextEditingController(),
    'Boundaries_West_SiteVisit': TextEditingController(),
    'Boundaries_West_LegalDocuments': TextEditingController(),
    'Boundaries_MatchingWithSite': TextEditingController(),

    // SECTION 6: STRUCTURAL DETAILS
    'Type of Construction Structure': TextEditingController(),
    'Quality of Construction': TextEditingController(),
    'Foundation Type': TextEditingController(),
    'Roof Type': TextEditingController(),
    'Masonry Type': TextEditingController(),
    'Walls': TextEditingController(),
    'Doors and Windows': TextEditingController(),
    'Finishing': TextEditingController(),
    'Flooring': TextEditingController(),
    'Any Other Construction Specifications': TextEditingController(),
    'Does Property fall in Demolition List?': TextEditingController(),

    // SECTION 7: PROPERTY STAGE OF CONSTRUCTION
    'Foundation_AllottedConstructionStage': TextEditingController(),
    'Foundation_PresentCompletion': TextEditingController(),
    'Foundation_NoOfFloorsCompleted': TextEditingController(),
    'Plinth_AllottedConstructionStage': TextEditingController(),
    'Plinth_PresentCompletion': TextEditingController(),
    'Plinth_NoOfFloorsCompleted': TextEditingController(),
    'BrickworkUptoSlab_AllottedConstructionStage': TextEditingController(),
    'BrickworkUptoSlab_PresentCompletion': TextEditingController(),
    'BrickworkUptoSlab_NoOfFloorsCompleted': TextEditingController(),
    'SlabRCCCasting_AllottedConstructionStage': TextEditingController(),
    'SlabRCCCasting_PresentCompletion': TextEditingController(),
    'SlabRCCCasting_NoOfFloorsCompleted': TextEditingController(),
    'InsideOutsidePlaster_AllottedConstructionStage': TextEditingController(),
    'InsideOutsidePlaster_PresentCompletion': TextEditingController(),
    'InsideOutsidePlaster_NoOfFloorsCompleted': TextEditingController(),
    'FlooringWork_AllottedConstructionStage': TextEditingController(),
    'FlooringWork_PresentCompletion': TextEditingController(),
    'FlooringWork_NoOfFloorsCompleted': TextEditingController(),
    'ElectrificationWork_AllottedConstructionStage': TextEditingController(),
    'ElectrificationWork_PresentCompletion': TextEditingController(),
    'ElectrificationWork_NoOfFloorsCompleted': TextEditingController(),
    'WoodworkPainting_AllottedConstructionStage': TextEditingController(),
    'WoodworkPainting_PresentCompletion': TextEditingController(),
    'WoodworkPainting_NoOfFloorsCompleted': TextEditingController(),
    'TotalCompletion_AllottedConstructionStage': TextEditingController(),
    'TotalCompletion_PresentCompletion': TextEditingController(),
    'TotalCompletion_NoOfFloorsCompleted': TextEditingController(),
    'RecommendedAmountInPercent': TextEditingController(),

    // SECTION 8: DOCUMENTS AND PERMISSIONS
    'Layout Plans Details': TextEditingController(),
    'Building Plan Details': TextEditingController(),
    'Construction Permission Number & Date/Commencement Certificate Details': TextEditingController(),
    'Occupation/ Completion Certificate Details': TextEditingController(),
    'Title Documents Verification Certificate': TextEditingController(),
    'Latest Ownership Document with Address and Area under Transaction': TextEditingController(),
    'Any Other Documents': TextEditingController(),
    'Deviations Observed on Site with Approved Plan': TextEditingController(),
    'If Approved Plans are not available, Construction done as per Local Bylaws': TextEditingController(),
    'Permissible FSI': TextEditingController(),
    'Is the Property Mortgaged or Disputed?': TextEditingController(),
    'Value/ Purchase Price paid as per Sale Deed': TextEditingController(),
    'Present Market Rate of the Property': TextEditingController(),
    'Details of recent transaction in the neighborhood, if any': TextEditingController(),

    //SECTION 9: VALUATION REPORT - Land
    'Land Area (Cents)_AsPerSite': TextEditingController(),
    'Land Area (Cents)_AsPerPlan': TextEditingController(),
    'Land Area (Cents)_AsPerLegalDoc': TextEditingController(),
    'Undivided Share of Land (in Cents)': TextEditingController(),
    'Adopted Land Area (in Cents)': TextEditingController(),
    'Adopted Land Rate (in Rs./Cents)': TextEditingController(),
    'Guideline Rate for Land': TextEditingController(),
    'LAND VALUE (in Rs.)': TextEditingController(),

    // SECTION 9: VALUATION REPORT - Building
    'Basement Floor_Area As per Site': TextEditingController(),
    'Basement Floor_Area As per Documents': TextEditingController(),
    'Basement Floor_Deviation': TextEditingController(),
    'Basement Floor_Adopted Built-up Area': TextEditingController(),
    'Basement Floor_Adopted Construction Rate': TextEditingController(),
    'Basement Floor_Replacement Cost': TextEditingController(),

    'Stilt Floor_Area As per Site': TextEditingController(),
    'Stilt Floor_Area As per Documents': TextEditingController(),
    'Stilt Floor_Deviation': TextEditingController(),
    'Stilt Floor_Adopted Built-up Area': TextEditingController(),
    'Stilt Floor_Adopted Construction Rate': TextEditingController(),
    'Stilt Floor_Replacement Cost': TextEditingController(),

    'Ground Floor_Area As per Site': TextEditingController(),
    'Ground Floor_Area As per Documents': TextEditingController(),
    'Ground Floor_Deviation': TextEditingController(),
    'Ground Floor_Adopted Built-up Area': TextEditingController(),
    'Ground Floor_Adopted Construction Rate': TextEditingController(),
    'Ground Floor_Replacement Cost': TextEditingController(),

    'First Floor_Area As per Site': TextEditingController(),
    'First Floor_Area As per Documents': TextEditingController(),
    'First Floor_Deviation': TextEditingController(),
    'First Floor_Adopted Built-up Area': TextEditingController(),
    'First Floor_Adopted Construction Rate': TextEditingController(),
    'First Floor_Replacement Cost': TextEditingController(),

    'Second Floor_Area As per Site': TextEditingController(),
    'Second Floor_Area As per Documents': TextEditingController(),
    'Second Floor_Deviation': TextEditingController(),
    'Second Floor_Adopted Built-up Area': TextEditingController(),
    'Second Floor_Adopted Construction Rate': TextEditingController(),
    'Second Floor_Replacement Cost': TextEditingController(),

    'Third Floor_Area As per Site': TextEditingController(),
    'Third Floor_Area As per Documents': TextEditingController(),
    'Third Floor_Deviation': TextEditingController(),
    'Third Floor_Adopted Built-up Area': TextEditingController(),
    'Third Floor_Adopted Construction Rate': TextEditingController(),
    'Third Floor_Replacement Cost': TextEditingController(),

    'Fourth Floor_Area As per Site': TextEditingController(),
    'Fourth Floor_Area As per Documents': TextEditingController(),
    'Fourth Floor_Deviation': TextEditingController(),
    'Fourth Floor_Adopted Built-up Area': TextEditingController(),
    'Fourth Floor_Adopted Construction Rate': TextEditingController(),
    'Fourth Floor_Replacement Cost': TextEditingController(),

    'Fifth Floor_Area As per Site': TextEditingController(),
    'Fifth Floor_Area As per Documents': TextEditingController(),
    'Fifth Floor_Deviation': TextEditingController(),
    'Fifth Floor_Adopted Built-up Area': TextEditingController(),
    'Fifth Floor_Adopted Construction Rate': TextEditingController(),
    'Fifth Floor_Replacement Cost': TextEditingController(),

    'Total_Area As per Site': TextEditingController(),
    'Total_Area As per Documents': TextEditingController(),
    'Total_Deviation': TextEditingController(),
    'Total_Adopted Built-up Area': TextEditingController(),
    'Total_Adopted Construction Rate': TextEditingController(), // Note: this field is not in the image but logically should be
    'Total_Replacement Cost': TextEditingController(),

    'Depreciation %': TextEditingController(),
    'Net Replacement Cost (in Rs.)': TextEditingController(),
    'No. of Car Parking': TextEditingController(),
    'Value of Parking (in Rs.)': TextEditingController(),
    'Value of Other Amenities (in Rs.)': TextEditingController(),
    'BUILDING VALUE / Insurable Value (in Rs.)': TextEditingController(),
    'Building Value as per Govt Guideline Rate (in Rs.)': TextEditingController(),

    // SECTION 9: FINAL VALUES (New additions from screenshot)
    'Estimated Cost to Complete the Property (in Rs.)': TextEditingController(),
    'Guideline Value (in Rs.)': TextEditingController(),
    'Estimated Rental Value of Building': TextEditingController(),
    'Market Value (in Rs.)': TextEditingController(),
    'Market Value (in Words)': TextEditingController(),
    'State the Source for Arriving at the Market Value': TextEditingController(),
    'Realizable value (in Rs.)': TextEditingController(),
    'Realizable value (%)': TextEditingController(), // For the 90%
    'Forced Sale Value (in Rs.)': TextEditingController(),
    'Forced Sale Value (%)': TextEditingController(), // For the 80%

    // SECTION 10: REMARKS & DECLARATION (No corresponding UI input, just for PDF)
    'Remarks_PropertyDescription': TextEditingController(text: 'THE PROPERTY IS A RESIDENTIAL BUILDING WHOSE CONSTRUCTION IS UNDER PROGRESS AND PLASTERING COMPLETED. THE PENDING WORKS ARE SANITARY FITTINGS, ELECTRICAL SWITCHES FINISHING WORKS AND FLOORING'),
    'Declaration_Point1': TextEditingController(text: 'The information furnished in this report is true and correct to the best of my knowledge and belief.'),
    'Declaration_Point2': TextEditingController(text: 'I have no direct or indirect interest in the property valued.'),
    'Declaration_Point3': TextEditingController(text: 'I / My representative MYSELF have/ has personally visited the property by going to the site and inspected all items thoroughly.'),
    'Declaration_Point4': TextEditingController(text: 'The legal aspects are out of the scope of this valuation report.'),
    'Declaration_Point5': TextEditingController(text: 'I have never been debarred or convicted by any court of law.'),
    'Declaration_Point6': TextEditingController(text: 'The valuation report has been prepared for mortgage purpose.'),

    // SECTION 11: Annexure I - Valuer confirmation in case of Construction Deviation
    'ConstructionDeviation_ApprovedPlanAvailable': TextEditingController(),
    'ConstructionDeviation_DeviationOnSecurityProperty': TextEditingController(),
    'ConstructionDeviation_PropertyTaxPaidReceipts': TextEditingController(),
    'ConstructionDeviation_LatestLandRecordAvailability': TextEditingController(),
    'ConstructionDeviation_FSIRARFAR_LocalAuthority': TextEditingController(),
    'ConstructionDeviation_MaxDeviationPermitted': TextEditingController(),
    'ConstructionDeviation_FSIRARFAR_Agreement': TextEditingController(),
    'ConstructionDeviation_FSIRARFAR_ValuerConfirmed': TextEditingController(),
    'ConstructionDeviation_PropertyAcceptedAsSecurity': TextEditingController(),
    'ConstructionDeviation_HerebyConfirmCertify': TextEditingController(),
  };

  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = []; // Changed to store XFile objects

  // Helper function to create sub-tables for nested information
  pw.Table createSubTable(List<String> keys, {double fontSize = 9, double padding = 1.5}) {
    return pw.Table(
      border: pw.TableBorder.all(),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(3),
      },
      children: keys.map((key) {
        return pw.TableRow(
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.all(padding),
              child: pw.Text(
                key,
                style: pw.TextStyle(fontSize: fontSize),
              ),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.all(padding),
              child: pw.Text(
                controllers[key]?.text ?? '',
                style: pw.TextStyle(fontSize: fontSize),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  pw.TableRow _buildConstructionPdfTableRow(
      String sNo,
      String activity,
      String allottedConstructionStageKey,
      String presentCompletionKey,
      String noOfFloorsCompletedKey,
      String? recommendedAmountKey) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(2),
          child: pw.Text(sNo, style: const pw.TextStyle(fontSize: 9.5)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(2),
          child: pw.Text(activity, style: const pw.TextStyle(fontSize: 9.5)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(2),
          child: pw.Text(controllers[allottedConstructionStageKey]?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(2),
          child: pw.Text(controllers[presentCompletionKey]?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(2),
          child: pw.Text(controllers[noOfFloorsCompletedKey]?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(2),
          child: pw.Text(recommendedAmountKey != null ? (controllers[recommendedAmountKey]?.text ?? '') : '', style: const pw.TextStyle(fontSize: 9.5)),
        ),
      ],
    );
  }

  pw.TableRow _buildBuildingPdfTableRow(
      String floor,
      String areaSiteKey,
      String areaDocKey,
      String deviationKey,
      String adoptedAreaKey,
      String adoptedRateKey,
      String replacementCostKey,
      {bool isTotalRow = false}) {
    return pw.TableRow(
      decoration: isTotalRow ? const pw.BoxDecoration(color: pdfLib.PdfColors.grey200) : null,
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(2),
          child: pw.Text(
            floor,
            style: pw.TextStyle(fontWeight: isTotalRow ? pw.FontWeight.bold : pw.FontWeight.normal, fontSize: 9.5),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(2),
          child: pw.Text(
            controllers[areaSiteKey]?.text ?? '',
            style: pw.TextStyle(fontWeight: isTotalRow ? pw.FontWeight.bold : pw.FontWeight.normal, fontSize: 9.5),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(2),
          child: pw.Text(
            controllers[areaDocKey]?.text ?? '',
            style: pw.TextStyle(fontWeight: isTotalRow ? pw.FontWeight.bold : pw.FontWeight.normal, fontSize: 9.5),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(2),
          child: pw.Text(
            controllers[deviationKey]?.text ?? '',
            style: pw.TextStyle(fontWeight: isTotalRow ? pw.FontWeight.bold : pw.FontWeight.normal, fontSize: 9.5),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(2),
          child: pw.Text(
            controllers[adoptedAreaKey]?.text ?? '',
            style: pw.TextStyle(fontWeight: isTotalRow ? pw.FontWeight.bold : pw.FontWeight.normal, fontSize: 9.5),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(2),
          child: pw.Text(
            controllers[adoptedRateKey]?.text ?? '',
            style: pw.TextStyle(fontWeight: isTotalRow ? pw.FontWeight.bold : pw.FontWeight.normal, fontSize: 9.5),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(2),
          child: pw.Text(
            controllers[replacementCostKey]?.text ?? '',
            style: pw.TextStyle(fontWeight: isTotalRow ? pw.FontWeight.bold : pw.FontWeight.normal, fontSize: 9.5),
          ),
        ),
      ],
    );
  }

  // Method to pick images from gallery
  Future<void> _pickImage() async {
    // Show a dialog to choose between gallery and camera
    if (kIsWeb) {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _images.add(image); // Store XFile directly
        });
      }
    } else {
      // For mobile platforms, give option for gallery or camera
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        _images.add(image); // Store XFile directly
                      });
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      setState(() {
                        _images.add(image); // Store XFile directly
                      });
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  // Method to remove an image
  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  // Method to get current location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enable location services")),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permission denied")),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission permanently denied")),
      );
      return;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _latController.text = position.latitude.toString();
        _lonController.text = position.longitude.toString();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error getting location: $e")),
      );
      print('Error getting location: $e'); // Keep print for debugging in console
    }
  }


  Future<void> _generatePdf() async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(now);

    // --- PAGE 1 CONTENT ---
    pdf.addPage(
      pw.MultiPage(
        pageFormat: pdfLib.PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(22), // Adjusted margin for more space
        build: (context) => [
          pw.Center(
            child: pw.Text(
              'Report Format (Federal)\nLand and Building Method',
              style: pw.TextStyle(
                fontSize: 15, // Adjusted font size
                fontWeight: pw.FontWeight.bold,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ),
          pw.SizedBox(height: 6), // Adjusted height
          pw.Text(
            'Date of Valuation: $formattedDate',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10), // Adjusted font size
          ),
          pw.SizedBox(height: 20), // Adjusted height
          pw.Text(
            '1. INTRODUCTION',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11), // Adjusted font size
          ),
          pw.SizedBox(height: 20), // Adjusted height
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(5),
            },
            children: [
              ...[
                'Applicant Name and Branch Details',
                'Owner of the Property',
                'Name of the prospective purchaser(s)',
                'Builder Name and RERA ID',
                'Property Description',
                'Person Met on Site and his/ her relationship with the Applicant',
                'Property Address as per Site Visit',
              ].map(
                (key) => pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2), // Adjusted padding
                      child: pw.Text(
                        key,
                        style: const pw.TextStyle(fontSize: 9.5), // Adjusted font size
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2), // Adjusted padding
                      child: pw.Text(
                        controllers[key]?.text ?? '',
                        style: const pw.TextStyle(fontSize: 9.5), // Adjusted font size
                      ),
                    ),
                  ],
                ),
              ),
              pw.TableRow(
                children: [
                  pw.SizedBox(),
                  createSubTable([
                    'Business Name',
                    'House/ Door / Unit/ Flat/ Shop /Office / Gala No.',
                    'Plot No.',
                    'Floor',
                    'Project Name/ Building Name',
                    'Locality/ Sub Locality',
                    'Street Name/ Road No',
                    'Nearest Landmark',
                    'City/ Town',
                    'Village',
                    'Pincode',
                  ], fontSize: 9.5, padding: 1.5), // Pass sizes to sub-table
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2), // Adjusted padding
                    child: pw.Text(
                      'Technical Address of Property',
                      style: const pw.TextStyle(fontSize: 9.5), // Adjusted font size
                    ),
                  ),
                  createSubTable([
                    'Plot No./Survey No./Khasra No.',
                    'Sub-zone (upvibhag)',
                    'Village_Technical',
                    'Sub district (Taluka)',
                    'District',
                    'State',
                  ], fontSize: 9.5, padding: 1.5), // Pass sizes to sub-table
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2), // Adjusted padding
                    child: pw.Text(
                      'Legal Address of Property',
                      style: const pw.TextStyle(fontSize: 9.5), // Adjusted font size
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2), // Adjusted padding
                    child: pw.Text(
                      controllers['Legal Address of Property']?.text ?? '',
                      style: const pw.TextStyle(fontSize: 9.5), // Adjusted font size
                    ),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20), // Adjusted height
          pw.Text(
            '2. PROPERTY DETAILS',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11), // Adjusted font size
          ),
          pw.SizedBox(height: 20), // Adjusted height

          // PROPERTY DETAILS TABLE (Existing)
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FlexColumnWidth(2),
            },
            children: [
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2), // Adjusted padding
                    child: pw.Text(
                      'Property Type',
                      style: const pw.TextStyle(fontSize: 9.5), // Adjusted font size
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2), // Adjusted padding
                    child: pw.Text(
                      controllers['Property Type']?.text ?? '',
                      style: const pw.TextStyle(fontSize: 9.5), // Adjusted font size
                    ),
                  ),
                  pw.SizedBox(),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2), // Adjusted padding
                    child: pw.Text(
                      'Property Usage',
                      style: const pw.TextStyle(fontSize: 9.5), // Adjusted font size
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2), // Adjusted padding
                    child: pw.Text(
                      controllers['Property Usage']?.text ?? '',
                      style: const pw.TextStyle(fontSize: 9.5), // Adjusted font size
                    ),
                  ),
                  pw.SizedBox(),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2), // Adjusted padding
                    child: pw.Text(
                      'Permitted Usage of the Property',
                      style: const pw.TextStyle(fontSize: 9.5), // Adjusted font size
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2), // Adjusted padding
                    child: pw.Text(
                      controllers['Permitted Usage of the Property']?.text ?? '',
                      style: const pw.TextStyle(fontSize: 9.5), // Adjusted font size
                    ),
                  ),
                  pw.SizedBox(),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2), // Adjusted padding
                    child: pw.Text(
                      'Within Municipal Limits? If No, Name of the local body/ Panchayat',
                      style: const pw.TextStyle(fontSize: 9.5), // Adjusted font size
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2), // Adjusted padding
                    child: pw.Text(
                      controllers['Within Municipal Limits']?.text ?? '',
                      style: const pw.TextStyle(fontSize: 9.5), // Adjusted font size
                    ),
                  ),
                  pw.SizedBox(),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2), // Adjusted padding
                    child: pw.Text(
                      'Municipal/ Panchayat Number of the Building',
                      style: const pw.TextStyle(fontSize: 9.5), // Adjusted font size
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2), // Adjusted padding
                    child: pw.Text(
                      controllers['Municipal Number']?.text ?? '',
                      style: const pw.TextStyle(fontSize: 9.5), // Adjusted font size
                    ),
                  ),
                  pw.SizedBox(),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2), // Adjusted padding
                    child: pw.Text(
                      'Construction Status',
                      style: const pw.TextStyle(fontSize: 9.5), // Adjusted font size
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2), // Adjusted padding
                    child: pw.Text(
                      controllers['Construction Status']?.text ?? '',
                      style: const pw.TextStyle(fontSize: 9.5), // Adjusted font size
                    ),
                  ),
                  pw.SizedBox(),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2), // Adjusted padding
                    child: pw.Text(
                      'Stage of construction (in %)',
                      style: const pw.TextStyle(fontSize: 9.5), // Adjusted font size
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2), // Adjusted padding
                    child: pw.Text(
                      controllers['% Complete']?.text ?? '', // Removed the '% Complete' text as it is a header
                      style: const pw.TextStyle(fontSize: 9.5), // Adjusted font size
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2), // Adjusted padding
                    child: pw.Text(
                      controllers['% Recommended']?.text ?? '', // Removed the '% Recommended' text as it is a header
                      style: const pw.TextStyle(fontSize: 9.5), // Adjusted font size
                    ),
                  ),
                ],
              ),
              ...[
                'Type of Occupancy',
                'Tenure (if Self-Occupied)',
                'Tenure (if Vacant)',
                'If rented, Tenant Details',
                'Customer Relationship with Occupant',
              ].map(
                (key) => pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2), // Adjusted padding
                      child: pw.Text(
                        key,
                        style: const pw.TextStyle(fontSize: 9.5), // Adjusted font size
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2), // Adjusted padding
                      child: pw.Text(
                        controllers[key]?.text ?? '',
                        style: const pw.TextStyle(fontSize: 9.5), // Adjusted font size
                      ),
                    ),
                    pw.SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );

    // --- PAGE 2, 3, 4 CONTENT (All remaining sections) ---
    pdf.addPage(
      pw.MultiPage(
        pageFormat: pdfLib.PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(22), // Consistent margin with page 1
        build: (context) => [
          // Continued PROPERTY DETAILS TABLE
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(5),
            },
            children: [
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Ownership Type', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Ownership Type']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Total No. of Blocks/ Buildings', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Total No. of Blocks/ Buildings']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('No. of Floors', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['No. of Floors']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('No. of Units', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Table(
                    border: pw.TableBorder.all(),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(2),
                            child: pw.Text('Total Units', style: const pw.TextStyle(fontSize: 9.5)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(2),
                            child: pw.Text('Units on each Floor', style: const pw.TextStyle(fontSize: 9.5)),
                          ),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(2),
                            child: pw.Text(controllers['No. of Units_Total Units']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(2),
                            child: pw.Text(controllers['No. of Units_Units on each Floor']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Year Built / Age of Property (in Years)', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      '${controllers['Year Built / Age of Property (in Years)']?.text ?? ''} ${controllers['Year Built / Age of the Property (in Years)_Years']?.text ?? ''}',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Residual Age of the Property (in Years)', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Residual Age of the Property (in Years)']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Maintenance Level of Building', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Maintenance Level of Building']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Amenities', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(controllers['Amenities']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text('Lifts: ${controllers['Amenities_Lifts']?.text ?? ''}', style: const pw.TextStyle(fontSize: 9.5)),
                      ),
                    ],
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Whether the Building is constructed strictly according to Plan approved by Government authority? Give details', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Whether the Building is constructed strictly according to Plan approved by Government authority? Give details']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                ],
              ),
            ],
          ),
          // SECTION 3: UNIT DETAILS
          pw.SizedBox(height: 20),
          pw.Text(
            '3. UNIT DETAILS',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
          ),
          pw.SizedBox(height: 20),
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(5),
            },
            children: [
              ...[
                'Basement',
                'Ground Floor',
                'First Floor',
                'Second Floor',
                'Third Floor',
                'Fourth Floor',
                'Fifth Floor',
              ].map(
                (key) => pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2),
                      child: pw.Text(
                        key,
                        style: const pw.TextStyle(fontSize: 9.5),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2),
                      child: pw.Text(
                        controllers[key]?.text ?? '',
                        style: const pw.TextStyle(fontSize: 9.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // SECTION 4: SURROUNDING LOCALITY DETAILS
          pw.SizedBox(height: 20),
          pw.Text(
            '4. SURROUNDING LOCALITY DETAILS',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
          ),
          pw.SizedBox(height: 20),
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(5),
            },
            children: [
              ...[
                'Type of Area',
                'Classification of Area',
                'Development in Vicinity (%)',
                'Quality of Infrastructure in the Vicinity',
                'Class of Locality',
                'Nature of Locality',
                'Details of the Route through which Property can be reached',
                'Has the Property got direct and independent Access?',
                'Is the property accessible by car/ mode of accessibility available?',
                'Proximity to Civic Amenities',
                'Nearest Railway Station (Distance & Name)',
                'Nearest Hospital (Distance & Name)',
                'Nearest City Center (Distance & Name)',
                'Is this Corner Property?',
                'Property Identified Through',
                'Property Demarcated',
                'Nature of Land/ Type of Use to which it can be put',
                'If Others, Give Details',
                'General Description of Layout',
                'If Others, Give Details_2',
                'Other Developments on the Property excluding Building, if any',
              ].map(
                (key) => pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2),
                      child: pw.Text(
                        key.replaceAll('_2', ''), // Remove '_2' for display
                        style: const pw.TextStyle(fontSize: 9.5),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2),
                      child: pw.Text(
                        controllers[key]?.text ?? '',
                        style: const pw.TextStyle(fontSize: 9.5),
                      ),
                    ),
                  ],
                ),
              ),
              // Special handling for 'Approach Road Details' with nested values
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      'Approach Road Details',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(controllers['Approach Road Details']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          '${controllers['Approach Road Details_Width']?.text ?? ''} M',
                          style: const pw.TextStyle(fontSize: 9.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(5),
            },
            children: [
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      'Marketability',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      controllers['Marketability']?.text ?? '',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      'Encroachment Details, if any',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      controllers['Encroachment Details, if any']?.text ?? '',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      'Is the Property Prone to any Disaster?',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      controllers['Is the Property Prone to any Disaster?']?.text ?? '',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      'Any Locational Advantages Noted',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      controllers['Any Locational Advantages Noted']?.text ?? '',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          // SECTION 5: PHYSICAL DETAILS
          pw.Text(
            '5. PHYSICAL DETAILS',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
          ),
          pw.SizedBox(height: 20),
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: const pw.FlexColumnWidth(2),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FlexColumnWidth(3),
            },
            children: [
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Boundaries', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Site Visit', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Legal Documents', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('North', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Boundaries_North_SiteVisit']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Boundaries_North_LegalDocuments']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('South', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Boundaries_South_SiteVisit']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Boundaries_South_LegalDocuments']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('East', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Boundaries_East_SiteVisit']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Boundaries_East_LegalDocuments']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('West', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Boundaries_West_SiteVisit']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Boundaries_West_LegalDocuments']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Boundaries matching with site?', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Boundaries_MatchingWithSite']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.SizedBox(), // Empty cell for the third column
                ],
              ),
            ],
          ),

          // SECTION 6: STRUCTURAL DETAILS
          pw.SizedBox(height: 20),
          pw.Text(
            '6. STRUCTURAL DETAILS',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
          ),
          pw.SizedBox(height: 20),
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(5),
            },
            children: [
              ...[
                'Type of Construction Structure',
                'Quality of Construction',
                'Foundation Type',
                'Roof Type',
                'Masonry Type',
                'Walls',
                'Doors and Windows',
                'Finishing',
                'Flooring',
                'Any Other Construction Specifications',
                'Does Property fall in Demolition List?',
              ].map(
                (key) => pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2),
                      child: pw.Text(
                        key,
                        style: const pw.TextStyle(fontSize: 9.5),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2),
                      child: pw.Text(
                        controllers[key]?.text ?? '',
                        style: const pw.TextStyle(fontSize: 9.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // SECTION 7: PROPERTY STAGE OF CONSTRUCTION
          pw.SizedBox(height: 20),
          pw.Text(
            '7. PROPERTY STAGE OF CONSTRUCTION',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
          ),
          pw.SizedBox(height: 20),
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: const pw.FlexColumnWidth(0.5),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(1.5),
              3: const pw.FlexColumnWidth(1.5),
              4: const pw.FlexColumnWidth(1.5),
              5: const pw.FlexColumnWidth(1.5),
            },
            children: [
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('S. No', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Activity', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Allotted Construction Stage in %', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Present Completion in %', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('No. of Floors Completed', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Recommended Amount in %', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                ],
              ),
              _buildConstructionPdfTableRow(
                  '1',
                  'Foundation',
                  'Foundation_AllottedConstructionStage',
                  'Foundation_PresentCompletion',
                  'Foundation_NoOfFloorsCompleted',
                  null),
              _buildConstructionPdfTableRow(
                  '2',
                  'Plinth',
                  'Plinth_AllottedConstructionStage',
                  'Plinth_PresentCompletion',
                  'Plinth_NoOfFloorsCompleted',
                  null),
              _buildConstructionPdfTableRow(
                  '3',
                  'Brickwork upto Slab',
                  'BrickworkUptoSlab_AllottedConstructionStage',
                  'BrickworkUptoSlab_PresentCompletion',
                  'BrickworkUptoSlab_NoOfFloorsCompleted',
                  null),
              _buildConstructionPdfTableRow(
                  '4',
                  'Slab/ RCC Casting',
                  'SlabRCCCasting_AllottedConstructionStage',
                  'SlabRCCCasting_PresentCompletion',
                  'SlabRCCCasting_NoOfFloorsCompleted',
                  null),
              _buildConstructionPdfTableRow(
                  '5',
                  'Inside/ Outside Plaster',
                  'InsideOutsidePlaster_AllottedConstructionStage',
                  'InsideOutsidePlaster_PresentCompletion',
                  'InsideOutsidePlaster_NoOfFloorsCompleted',
                  null),
              _buildConstructionPdfTableRow(
                  '6',
                  'Flooring Work',
                  'FlooringWork_AllottedConstructionStage',
                  'FlooringWork_PresentCompletion',
                  'FlooringWork_NoOfFloorsCompleted',
                  null),
              _buildConstructionPdfTableRow(
                  '7',
                  'Electrification Work',
                  'ElectrificationWork_AllottedConstructionStage',
                  'ElectrificationWork_PresentCompletion',
                  'ElectrificationWork_NoOfFloorsCompleted',
                  null),
              _buildConstructionPdfTableRow(
                  '8',
                  'Woodwork & Painting',
                  'WoodworkPainting_AllottedConstructionStage',
                  'WoodworkPainting_PresentCompletion',
                  'WoodworkPainting_NoOfFloorsCompleted',
                  null),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      'Total Completion',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      controllers['TotalCompletion_AllottedConstructionStage']?.text ?? '',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      controllers['TotalCompletion_PresentCompletion']?.text ?? '',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      controllers['TotalCompletion_NoOfFloorsCompleted']?.text ?? '',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      controllers['RecommendedAmountInPercent']?.text ?? '',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // SECTION 8: DOCUMENTS AND PERMISSIONS - ALL OF IT
          pw.SizedBox(height: 20),
          pw.Text(
            '8. DOCUMENTS AND PERMISSIONS',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
          ),
          pw.SizedBox(height: 20),
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(5),
            },
            children: [
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      'Layout Plans Details',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      controllers['Layout Plans Details']?.text ?? '',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      'Building Plan Details',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      controllers['Building Plan Details']?.text ?? '',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      'Construction Permission Number & Date/Commencement Certificate Details',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      controllers['Construction Permission Number & Date/Commencement Certificate Details']?.text ?? '',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      'Occupation/ Completion Certificate Details',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      controllers['Occupation/ Completion Certificate Details']?.text ?? 'NOT OBTAINED',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      'Title Documents Verification Certificate',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      controllers['Title Documents Verification Certificate']?.text ?? 'LEGAL SCRUTINY REPORT VERIFIED',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      'Latest Ownership Document with Address and Area under Transaction',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      controllers['Latest Ownership Document with Address and Area under Transaction']?.text ?? 'PROVIDED FOR VERIFICATION',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      'Any Other Documents',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      controllers['Any Other Documents']?.text ?? 'NIL',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      'Deviations Observed on Site with Approved Plan',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      controllers['Deviations Observed on Site with Approved Plan']?.text ?? 'None (Low)',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      'If Approved Plans are not available, Construction done as per Local Bylaws',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      controllers['If Approved Plans are not available, Construction done as per Local Bylaws']?.text ?? 'Yes',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      'Permissible FSI',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      controllers['Permissible FSI']?.text ?? '0.8',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      'Is the Property Mortgaged or Disputed?',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      controllers['Is the Property Mortgaged or Disputed?']?.text ?? 'No (Low)',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      'Value/ Purchase Price paid as per Sale Deed',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      controllers['Value/ Purchase Price paid as per Sale Deed']?.text ?? '9,40,000',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      'Present Market Rate of the Property',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      controllers['Present Market Rate of the Property']?.text ?? '21,04,000',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      'Details of recent transaction in the neighborhood, if any',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      controllers['Details of recent transaction in the neighborhood, if any']?.text ?? 'NOT OBTAINED',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // SECTION 9: VALUATION REPORT (Land)
          pw.SizedBox(height: 20),
          pw.Text(
            '9. VALUATION REPORT',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
          ),
          pw.SizedBox(height: 20),
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(2),
              3: const pw.FlexColumnWidth(2),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: pdfLib.PdfColors.grey200),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('LAND', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.SizedBox(),
                  pw.SizedBox(),
                  pw.SizedBox(),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Land Area (Cents)', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Land Area (Cents)_AsPerSite']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Land Area (Cents)_AsPerPlan']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Land Area (Cents)_AsPerLegalDoc']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Land Area (Cents)_AsPerSite']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Land Area (Cents)_AsPerPlan']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Land Area (Cents)_AsPerLegalDoc']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Undivided Share of Land (in Cents)', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Undivided Share of Land (in Cents)']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.SizedBox(),
                  pw.SizedBox(),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Adopted Land Area (in Cents)', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Adopted Land Area (in Cents)']?.text ?? '', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.SizedBox(),
                  pw.SizedBox(),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Adopted Land Rate (in Rs./Cents)', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Adopted Land Rate (in Rs./Cents)']?.text ?? '', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.SizedBox(),
                  pw.SizedBox(),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Guideline Rate for Land', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Guideline Rate for Land']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.SizedBox(),
                  pw.SizedBox(),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: pdfLib.PdfColors.grey200),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('LAND VALUE: (in Rs.)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['LAND VALUE (in Rs.)']?.text ?? '', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.SizedBox(),
                  pw.SizedBox(),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          // New BUILDING table
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: const pw.FlexColumnWidth(1.5),
              1: const pw.FlexColumnWidth(1.5),
              2: const pw.FlexColumnWidth(1.5),
              3: const pw.FlexColumnWidth(1),
              4: const pw.FlexColumnWidth(1.5),
              5: const pw.FlexColumnWidth(1.5),
              6: const pw.FlexColumnWidth(1.5),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: pdfLib.PdfColors.grey200),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('BUILDING', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.SizedBox(),
                  pw.SizedBox(),
                  pw.SizedBox(),
                  pw.SizedBox(),
                  pw.SizedBox(),
                  pw.SizedBox(),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Floor', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Area As per Site\n(in Sq Feet)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Area As per Documents\n(in Sq Feet)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Deviation', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Adopted Built-up Area\n(in Sq Feet)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Adopted Construction Rate\n(in Rs/ Sq Feet)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Replacement Cost (in Rs.)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                ],
              ),
              _buildBuildingPdfTableRow('Basement Floor',
                  'Basement Floor_Area As per Site',
                  'Basement Floor_Area As per Documents',
                  'Basement Floor_Deviation',
                  'Basement Floor_Adopted Built-up Area',
                  'Basement Floor_Adopted Construction Rate',
                  'Basement Floor_Replacement Cost'),
              _buildBuildingPdfTableRow('Stilt Floor',
                  'Stilt Floor_Area As per Site',
                  'Stilt Floor_Area As per Documents',
                  'Stilt Floor_Deviation',
                  'Stilt Floor_Adopted Built-up Area',
                  'Stilt Floor_Adopted Construction Rate',
                  'Stilt Floor_Replacement Cost'),
              _buildBuildingPdfTableRow('Ground Floor',
                  'Ground Floor_Area As per Site',
                  'Ground Floor_Area As per Documents',
                  'Ground Floor_Deviation',
                  'Ground Floor_Adopted Built-up Area',
                  'Ground Floor_Adopted Construction Rate',
                  'Ground Floor_Replacement Cost'),
              _buildBuildingPdfTableRow('First Floor',
                  'First Floor_Area As per Site',
                  'First Floor_Area As per Documents',
                  'First Floor_Deviation',
                  'First Floor_Adopted Built-up Area',
                  'First Floor_Adopted Construction Rate',
                  'First Floor_Replacement Cost'),
              _buildBuildingPdfTableRow('Second Floor',
                  'Second Floor_Area As per Site',
                  'Second Floor_Area As per Documents',
                  'Second Floor_Deviation',
                  'Second Floor_Adopted Built-up Area',
                  'Second Floor_Adopted Construction Rate',
                  'Second Floor_Replacement Cost'),
              _buildBuildingPdfTableRow('Third Floor',
                  'Third Floor_Area As per Site',
                  'Third Floor_Area As per Documents',
                  'Third Floor_Deviation',
                  'Third Floor_Adopted Built-up Area',
                  'Third Floor_Adopted Construction Rate',
                  'Third Floor_Replacement Cost'),
              _buildBuildingPdfTableRow('Fourth Floor',
                  'Fourth Floor_Area As per Site',
                  'Fourth Floor_Area As per Documents',
                  'Fourth Floor_Deviation',
                  'Fourth Floor_Adopted Built-up Area',
                  'Fourth Floor_Adopted Construction Rate',
                  'Fourth Floor_Replacement Cost'),
              _buildBuildingPdfTableRow('Fifth Floor',
                  'Fifth Floor_Area As per Site',
                  'Fifth Floor_Area As per Documents',
                  'Fifth Floor_Deviation',
                  'Fifth Floor_Adopted Built-up Area',
                  'Fifth Floor_Adopted Construction Rate',
                  'Fifth Floor_Replacement Cost'),
              _buildBuildingPdfTableRow('Total',
                  'Total_Area As per Site',
                  'Total_Area As per Documents',
                  'Total_Deviation',
                  'Total_Adopted Built-up Area',
                  'Total_Adopted Construction Rate',
                  'Total_Replacement Cost', isTotalRow: true),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(5),
            },
            children: [
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Depreciation %', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Depreciation %']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Net Replacement Cost (in Rs.)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Net Replacement Cost (in Rs.)']?.text ?? '', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: const pw.FlexColumnWidth(2),
              1: const pw.FlexColumnWidth(1),
              2: const pw.FlexColumnWidth(2),
              3: const pw.FlexColumnWidth(1),
              4: const pw.FlexColumnWidth(2),
              5: const pw.FlexColumnWidth(1), // Added for last value
            },
            children: [
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('No. of Car Parking', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['No. of Car Parking']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Value of Parking (in Rs.)', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Value of Parking (in Rs.)']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Value of Other Amenities (in Rs.)', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Value of Other Amenities (in Rs.)']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: pdfLib.PdfColors.grey200),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('BUILDING VALUE / Insurable Value (in Rs.)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.SizedBox(width: 0), // To occupy space and align next cell
                  pw.SizedBox(width: 0),
                  pw.SizedBox(width: 0),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['BUILDING VALUE / Insurable Value (in Rs.)']?.text ?? '', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.SizedBox(width: 0),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: pdfLib.PdfColors.grey200),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Building Value as per Govt Guideline Rate (in Rs.)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.SizedBox(width: 0),
                  pw.SizedBox(width: 0),
                  pw.SizedBox(width: 0),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Building Value as per Govt Guideline Rate (in Rs.)']?.text ?? '', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.SizedBox(width: 0),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    // --- PAGE 5 CONTENT (FINAL VALUES, GEOLOCATION, REMARKS and DECLARATION) ---
    pdf.addPage(
      pw.MultiPage(
        pageFormat: pdfLib.PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(22),
        build: (context) => [
          pw.SizedBox(height: 20),
          pw.Text(
            '9. FINAL VALUES',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
          ),
          pw.SizedBox(height: 20),
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(1), // For the percentage column
            },
            children: [
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Estimated Cost to Complete the Property (in Rs.)', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Estimated Cost to Complete the Property (in Rs.)']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.SizedBox(), // Empty cell
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Guideline Value (in Rs.)', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Guideline Value (in Rs.)']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.SizedBox(), // Empty cell
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Estimated Rental Value of Building', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Estimated Rental Value of Building']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.SizedBox(), // Empty cell
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: pdfLib.PdfColors.grey200),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Market Value (in Rs.)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Market Value (in Rs.)']?.text ?? '', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.SizedBox(), // Empty cell
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Market Value (in Words)', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Market Value (in Words)']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.SizedBox(), // Empty cell
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('State the Source for Arriving at the Market Value', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['State the Source for Arriving at the Market Value']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.SizedBox(), // Empty cell
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Realizable value (in Rs.)', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Realizable value (in Rs.)']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Realizable value (%)']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Forced Sale Value (in Rs.)', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Forced Sale Value (in Rs.)']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(controllers['Forced Sale Value (%)']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 30),

          // New GEOLOCATION DETAILS section in PDF
          if (_latController.text.isNotEmpty || _lonController.text.isNotEmpty)
            ...[
              pw.Text(
                '10. GEOLOCATION DETAILS', // Renumbered
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
              ),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(5),
                },
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text('Latitude', style: const pw.TextStyle(fontSize: 9.5)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(_latController.text.isNotEmpty ? _latController.text : 'N/A', style: const pw.TextStyle(fontSize: 9.5)),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text('Longitude', style: const pw.TextStyle(fontSize: 9.5)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(_lonController.text.isNotEmpty ? _lonController.text : 'N/A', style: const pw.TextStyle(fontSize: 9.5)),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
            ],

          // SECTION 11: REMARKS (Renumbered)
          pw.Text(
            '11. REMARKS',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            controllers['Remarks_PropertyDescription']?.text ?? '',
            style: const pw.TextStyle(fontSize: 9.5),
          ),
          pw.SizedBox(height: 20),
          // DECLARATION
          pw.Text(
            'DECLARATION:',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
          ),
          pw.SizedBox(height: 10),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('(I) ${controllers['Declaration_Point1']?.text ?? ''}', style: const pw.TextStyle(fontSize: 9.5)),
              pw.SizedBox(height: 5),
              pw.Text('(II) ${controllers['Declaration_Point2']?.text ?? ''}', style: const pw.TextStyle(fontSize: 9.5)),
              pw.SizedBox(height: 5),
              pw.Text('(III) ${controllers['Declaration_Point3']?.text ?? ''}', style: const pw.TextStyle(fontSize: 9.5)),
              pw.SizedBox(height: 5),
              pw.Text('(IV) ${controllers['Declaration_Point4']?.text ?? ''}', style: const pw.TextStyle(fontSize: 9.5)),
              pw.SizedBox(height: 5),
              pw.Text('(V) ${controllers['Declaration_Point5']?.text ?? ''}', style: const pw.TextStyle(fontSize: 9.5)),
              pw.SizedBox(height: 5),
              pw.Text('(VI) ${controllers['Declaration_Point6']?.text ?? ''}', style: const pw.TextStyle(fontSize: 9.5)),
            ],
          ),
          pw.SizedBox(height: 40),
          pw.Text(
            '<ValuerSignature:150X150>',
            style: const pw.TextStyle(fontSize: 9.5),
          ),
          pw.Text(
            'Seal Signature of the Panel Valuer',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Report Date: $formattedDate',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5),
          ),
        ],
      ),
    );

    // --- PAGE 6 CONTENT (Annexure I) ---
    pdf.addPage(
      pw.MultiPage(
        pageFormat: pdfLib.PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(22),
        build: (context) => [
          pw.Center(
            child: pw.Text(
              'Annexure I- Valuer confirmation in case of Construction Deviation',
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Center(
            child: pw.Text(
              'Addendum proposed to the Valuation report by Valuer for all cases with deviations in Security',
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: const pw.FlexColumnWidth(0.5), // S No.
              1: const pw.FlexColumnWidth(3), // Description
              2: const pw.FlexColumnWidth(4), // Details
            },
            children: [
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('S No.', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Description', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text('Details', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text('1', style: const pw.TextStyle(fontSize: 9.5))),
                  pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text('Whether approved plan copy is available?', style: const pw.TextStyle(fontSize: 9.5))),
                  pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text(controllers['ConstructionDeviation_ApprovedPlanAvailable']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5))),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text('1(a)', style: const pw.TextStyle(fontSize: 9.5))),
                  pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text('If Yes - What is the deviation on security property?', style: const pw.TextStyle(fontSize: 9.5))),
                  pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text(controllers['ConstructionDeviation_DeviationOnSecurityProperty']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5))),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text('1(b)', style: const pw.TextStyle(fontSize: 9.5))),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('If no - whether the following additional documents are made available -', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                        pw.Text('Property Tax paid receipts over the last 3-4 years to confirm payment of taxes.', style: const pw.TextStyle(fontSize: 9.5)),
                        pw.Text('Latest land record availability in present owner\'s name.', style: const pw.TextStyle(fontSize: 9.5)),
                      ],
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(controllers['ConstructionDeviation_PropertyTaxPaidReceipts']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                        pw.Text(controllers['ConstructionDeviation_LatestLandRecordAvailability']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5)),
                      ],
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text('2', style: const pw.TextStyle(fontSize: 9.5))),
                  pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text('FSI/RAR/FAR prescribed by the local Authority/Town planning', style: const pw.TextStyle(fontSize: 9.5))),
                  pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text(controllers['ConstructionDeviation_FSIRARFAR_LocalAuthority']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5))),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text('3', style: const pw.TextStyle(fontSize: 9.5))),
                  pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text('Max deviation permitted from prescribed FSI/RAR/FAR', style: const pw.TextStyle(fontSize: 9.5))),
                  pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text(controllers['ConstructionDeviation_MaxDeviationPermitted']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5))),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text('4', style: const pw.TextStyle(fontSize: 9.5))),
                  pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text('FSI/RAR/FAR of the security property as per the agreement', style: const pw.TextStyle(fontSize: 9.5))),
                  pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text(controllers['ConstructionDeviation_FSIRARFAR_Agreement']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5))),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text('', style: const pw.TextStyle(fontSize: 9.5))),
                  pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text('FSI/RAR/FAR of the security property as confirmed by the valuer', style: const pw.TextStyle(fontSize: 9.5))),
                  pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text(controllers['ConstructionDeviation_FSIRARFAR_ValuerConfirmed']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5))),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text('5', style: const pw.TextStyle(fontSize: 9.5))),
                  pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text('Whether property can be accepted as security for the loan\n(Views/Remarks)', style: const pw.TextStyle(fontSize: 9.5))),
                  pw.Padding(padding: const pw.EdgeInsets.all(2), child: pw.Text(controllers['ConstructionDeviation_PropertyAcceptedAsSecurity']?.text ?? '', style: const pw.TextStyle(fontSize: 9.5))),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'I hereby confirm/ certify that ${controllers['ConstructionDeviation_HerebyConfirmCertify']?.text ?? ''}',
            style: const pw.TextStyle(fontSize: 9.5),
          ),
        ],
      ),
    );


    // --- PAGE 7 onwards: ATTACHED PHOTOS ---
    if (_images.isNotEmpty) {
      final double pageWidth = pdfLib.PdfPageFormat.a4.availableWidth - (2 * 22); // Subtract margins
      final double pageHeight = pdfLib.PdfPageFormat.a4.availableHeight - (2 * 22); // Subtract margins

      // Calculate desired image dimensions for 3 images per row, 2 rows (6 images total)
      // Allow for some padding between images
      const double imageHorizontalPadding = 10;
      const double imageVerticalPadding = 10;
      // Width for 3 images: (pageWidth - 2 * padding) / 3
      final double targetImageWidth = (pageWidth - 2 * imageHorizontalPadding) / 3;
      // Height for 2 rows: (pageHeight - padding for title - 2 * vertical padding) / 2
      // Assuming 30 for title and its padding, and 20 for row spacing
      final double targetImageHeight = (pageHeight - 30 - 2 * imageVerticalPadding) / 2;

      for (int i = 0; i < _images.length; i += 6) {
        final List<pw.Widget> pageImages = [];
        for (int j = 0; j < 6 && (i + j) < _images.length; j++) {
          final imageFile = _images[i + j];
          try {
            final imageBytes = await imageFile.readAsBytes();
            final pw.MemoryImage pwImage = pw.MemoryImage(imageBytes);

            // Calculate scaled dimensions to fit within target size without cropping
            double originalWidth = pwImage.width?.toDouble() ?? 1.0;
            double originalHeight = pwImage.height?.toDouble() ?? 1.0;

            double scale = 1.0;
            if (originalWidth > targetImageWidth) {
              scale = targetImageWidth / originalWidth;
            }
            if (originalHeight * scale > targetImageHeight) {
              scale = targetImageHeight / originalHeight;
            }

            final double finalWidth = originalWidth * scale;
            final double finalHeight = originalHeight * scale;

            pageImages.add(
              pw.SizedBox(
                width: targetImageWidth, // Allocate full cell width
                height: targetImageHeight, // Allocate full cell height
                child: pw.Center( // Center the image within its allocated space
                  child: pw.Image(
                    pwImage,
                    width: finalWidth,
                    height: finalHeight,
                    fit: pw.BoxFit.contain, // Use contain to avoid cropping
                  ),
                ),
              ),
            );
          } catch (e) {
            print('Error loading image: ${imageFile.name}, Error: $e');
            pageImages.add(
              pw.SizedBox(
                width: targetImageWidth,
                height: targetImageHeight,
                child: pw.Center(
                  child: pw.Text('Failed to load image: ${imageFile.name}'),
                ),
              ),
            );
          }
        }

        // Arrange images in a grid-like structure (2 rows of 3 images)
        List<pw.Widget> rows = [];
        for (int k = 0; k < pageImages.length; k += 3) {
          List<pw.Widget> rowChildren = [];
          for (int l = 0; l < 3 && (k + l) < pageImages.length; l++) {
            rowChildren.add(
              pw.Expanded(
                child: pageImages[k + l],
              ),
            );
          }
          rows.add(
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: rowChildren,
            ),
          );
          if (k + 3 < pageImages.length) {
            rows.add(pw.SizedBox(height: imageVerticalPadding)); // Space between rows
          }
        }

        pdf.addPage(
          pw.MultiPage(
            pageFormat: pdfLib.PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(22),
            build: (context) => [
              pw.Center(
                child: pw.Text(
                  '12. ATTACHED PHOTOS', // Renumbered
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Column(
                children: rows,
              ),
            ],
          ),
        );
      }
    }

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  Widget _buildTableHeaderCell(String text, {TextAlign textAlign = TextAlign.center}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
        textAlign: textAlign,
      ),
    );
  }

  Widget _buildTableCell(Widget child) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: child,
    );
  }

  TableRow _buildConstructionInputRow(
      String sNo,
      String activity,
      String allottedConstructionStageKey,
      String presentCompletionKey,
      String noOfFloorsCompletedKey,
      String? recommendedAmountKey) {
    return TableRow(
      children: [
        _buildTableCell(Text(sNo)),
        _buildTableCell(Text(activity)),
        _buildTableCell(TextField(
          controller: controllers[allottedConstructionStageKey],
          decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
        )),
        _buildTableCell(TextField(
          controller: controllers[presentCompletionKey],
          decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
        )),
        _buildTableCell(TextField(
          controller: controllers[noOfFloorsCompletedKey],
          decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
        )),
        _buildTableCell(
          recommendedAmountKey != null
              ? TextField(
                  controller: controllers[recommendedAmountKey],
                  decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                )
              : Container(),
        ),
      ],
    );
  }

  TableRow _buildBuildingInputRow(
      String floor,
      String areaSiteKey,
      String areaDocKey,
      String deviationKey,
      String adoptedAreaKey,
      String adoptedRateKey,
      String replacementCostKey,
      {bool isTotalRow = false}) {
    return TableRow(
      decoration: isTotalRow ? BoxDecoration(color: Colors.grey[200]) : null,
      children: [
        _buildTableCell(
          Text(
            floor,
            style: isTotalRow ? const TextStyle(fontWeight: FontWeight.bold) : null,
          ),
        ),
        _buildTableCell(TextField(
          controller: controllers[areaSiteKey],
          decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
          style: isTotalRow ? const TextStyle(fontWeight: FontWeight.bold) : null,
        )),
        _buildTableCell(TextField(
          controller: controllers[areaDocKey],
          decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
          style: isTotalRow ? const TextStyle(fontWeight: FontWeight.bold) : null,
        )),
        _buildTableCell(TextField(
          controller: controllers[deviationKey],
          decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
          style: isTotalRow ? const TextStyle(fontWeight: FontWeight.bold) : null,
        )),
        _buildTableCell(TextField(
          controller: controllers[adoptedAreaKey],
          decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
          style: isTotalRow ? const TextStyle(fontWeight: FontWeight.bold) : null,
        )),
        _buildTableCell(TextField(
          controller: controllers[adoptedRateKey],
          decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
          style: isTotalRow ? const TextStyle(fontWeight: FontWeight.bold) : null,
        )),
        _buildTableCell(TextField(
          controller: controllers[replacementCostKey],
          decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
          style: isTotalRow ? const TextStyle(fontWeight: FontWeight.bold) : null,
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Generator')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            // Section 1: INTRODUCTION
            ExpansionTile(
              title: const Text(
                "1. INTRODUCTION",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              children: [
                const SizedBox(height: 20),
                ...[
                  'Applicant Name and Branch Details',
                  'Owner of the Property',
                  'Name of the prospective purchaser(s)',
                  'Builder Name and RERA ID',
                  'Property Description',
                  'Person Met on Site and his/ her relationship with the Applicant',
                  'Property Address as per Site Visit',
                  'Business Name',
                  'House/ Door / Unit/ Flat/ Shop /Office / Gala No.',
                  'Plot No.',
                  'Floor',
                  'Project Name/ Building Name',
                  'Locality/ Sub Locality',
                  'Street Name/ Road No',
                  'Nearest Landmark',
                  'City/ Town',
                  'Village',
                  'Pincode',
                  'Plot No./Survey No./Khasra No.',
                  'Sub-zone (upvibhag)',
                  'Village_Technical',
                  'Sub district (Taluka)',
                  'District',
                  'State',
                  'Legal Address of Property',
                ].map(
                  (key) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TextField(
                      controller: controllers[key],
                      decoration: InputDecoration(
                        labelText: key,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Section 2: PROPERTY DETAILS
            ExpansionTile(
              title: const Text(
                "2. PROPERTY DETAILS",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              children: [
                const SizedBox(height: 20),
                ...[
                  'Property Type',
                  'Property Usage',
                  'Permitted Usage of the Property',
                  'Within Municipal Limits',
                  'Municipal Number',
                  'Construction Status',
                  '% Complete',
                  '% Recommended',
                  'Type of Occupancy',
                  'Tenure (if Self-Occupied)',
                  'Tenure (if Vacant)',
                  'If rented, Tenant Details',
                  'Customer Relationship with Occupant',
                ].map(
                  (key) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TextField(
                      controller: controllers[key],
                      decoration: InputDecoration(
                        labelText: key,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                ...[
                  'Ownership Type',
                  'Total No. of Blocks/ Buildings',
                  'No. of Floors',
                  'No. of Units_Total Units',
                  'No. of Units_Units on each Floor',
                  'Year Built / Age of Property (in Years)',
                  'Year Built / Age of the Property (in Years)_Years',
                  'Residual Age of the Property (in Years)',
                  'Maintenance Level of Building',
                  'Amenities',
                  'Amenities_Lifts',
                  'Whether the Building is constructed strictly according to Plan approved by Government authority? Give details',
                ].map(
                  (key) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TextField(
                      controller: controllers[key],
                      decoration: InputDecoration(
                        labelText: key,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Section 3: UNIT DETAILS
            ExpansionTile(
              title: const Text(
                "3. UNIT DETAILS",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              children: [
                const SizedBox(height: 20),
                ...[
                  'Basement',
                  'Ground Floor',
                  'First Floor',
                  'Second Floor',
                  'Third Floor',
                  'Fourth Floor',
                  'Fifth Floor',
                ].map(
                  (key) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TextField(
                      controller: controllers[key],
                      decoration: InputDecoration(
                        labelText: key,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Section 4: SURROUNDING LOCALITY DETAILS
            ExpansionTile(
              title: const Text(
                "4. SURROUNDING LOCALITY DETAILS",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              children: [
                const SizedBox(height: 20),
                ...[
                  'Type of Area',
                  'Classification of Area',
                  'Development in Vicinity (%)',
                  'Quality of Infrastructure in the Vicinity',
                  'Class of Locality',
                  'Nature of Locality',
                  'Details of the Route through which Property can be reached',
                  'Has the Property got direct and independent Access?',
                  'Is the property accessible by car/ mode of accessibility available?',
                  'Proximity to Civic Amenities',
                  'Nearest Railway Station (Distance & Name)',
                  'Nearest Hospital (Distance & Name)',
                  'Nearest City Center (Distance & Name)',
                  'Is this Corner Property?',
                  'Property Identified Through',
                  'Property Demarcated',
                  'Nature of Land/ Type of Use to which it can be put',
                  'If Others, Give Details',
                  'General Description of Layout',
                  'If Others, Give Details_2',
                  'Other Developments on the Property excluding Building, if any',
                  'Approach Road Details',
                  'Approach Road Details_Width',
                ].map(
                  (key) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TextField(
                      controller: controllers[key],
                      decoration: InputDecoration(
                        labelText: key.replaceAll('_2', ''), // Remove '_2' for display
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ...[
                  'Marketability',
                  'Encroachment Details, if any',
                  'Is the Property Prone to any Disaster?',
                  'Any Locational Advantages Noted',
                ].map(
                  (key) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TextField(
                      controller: controllers[key],
                      decoration: InputDecoration(
                        labelText: key,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Section 5: PHYSICAL DETAILS
            ExpansionTile(
              title: const Text(
                "5. PHYSICAL DETAILS",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              children: [
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text('Boundaries', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text('Site Visit', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text('Legal Documents', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                _buildBoundaryRow('North'),
                _buildBoundaryRow('South'),
                _buildBoundaryRow('East'),
                _buildBoundaryRow('West'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: TextField(
                    controller: controllers['Boundaries_MatchingWithSite'],
                    decoration: const InputDecoration(
                      labelText: 'Boundaries matching with site?',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Section 6: STRUCTURAL DETAILS
            ExpansionTile(
              title: const Text(
                "6. STRUCTURAL DETAILS",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              children: [
                const SizedBox(height: 20),
                ...[
                  'Type of Construction Structure',
                  'Quality of Construction',
                  'Foundation Type',
                  'Roof Type',
                  'Masonry Type',
                  'Walls',
                  'Doors and Windows',
                  'Finishing',
                  'Flooring',
                  'Any Other Construction Specifications',
                  'Does Property fall in Demolition List?',
                ].map(
                  (key) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TextField(
                      controller: controllers[key],
                      decoration: InputDecoration(
                        labelText: key,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Section 7: PROPERTY STAGE OF CONSTRUCTION
            ExpansionTile(
              title: const Text(
                "7. PROPERTY STAGE OF CONSTRUCTION",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              children: [
                const SizedBox(height: 20),
                Table(
                  border: TableBorder.all(),
                  children: [
                    TableRow(
                      children: [
                        _buildTableHeaderCell('S. No'),
                        _buildTableHeaderCell('Activity'),
                        _buildTableHeaderCell('Allotted Construction Stage in %'),
                        _buildTableHeaderCell('Present Completion in %'),
                        _buildTableHeaderCell('No. of Floors Completed'),
                        _buildTableHeaderCell('Recommended Amount in %'),
                      ],
                    ),
                    _buildConstructionInputRow(
                        '1',
                        'Foundation',
                        'Foundation_AllottedConstructionStage',
                        'Foundation_PresentCompletion',
                        'Foundation_NoOfFloorsCompleted',
                        null),
                    _buildConstructionInputRow(
                        '2',
                        'Plinth',
                        'Plinth_AllottedConstructionStage',
                        'Plinth_PresentCompletion',
                        'Plinth_NoOfFloorsCompleted',
                        null),
                    _buildConstructionInputRow(
                        '3',
                        'Brickwork upto Slab',
                        'BrickworkUptoSlab_AllottedConstructionStage',
                        'BrickworkUptoSlab_PresentCompletion',
                        'BrickworkUptoSlab_NoOfFloorsCompleted',
                        null),
                    _buildConstructionInputRow(
                        '4',
                        'Slab/ RCC Casting',
                        'SlabRCCCasting_AllottedConstructionStage',
                        'SlabRCCCasting_PresentCompletion',
                        'SlabRCCCasting_NoOfFloorsCompleted',
                        null),
                    _buildConstructionInputRow(
                        '5',
                        'Inside/ Outside Plaster',
                        'InsideOutsidePlaster_AllottedConstructionStage',
                        'InsideOutsidePlaster_PresentCompletion',
                        'InsideOutsidePlaster_NoOfFloorsCompleted',
                        null),
                    _buildConstructionInputRow(
                        '6',
                        'Flooring Work',
                        'FlooringWork_AllottedConstructionStage',
                        'FlooringWork_PresentCompletion',
                        'FlooringWork_NoOfFloorsCompleted',
                        null),
                    _buildConstructionInputRow(
                        '7',
                        'Electrification Work',
                        'ElectrificationWork_AllottedConstructionStage',
                        'ElectrificationWork_PresentCompletion',
                        'ElectrificationWork_NoOfFloorsCompleted',
                        null),
                    _buildConstructionInputRow(
                        '8',
                        'Woodwork & Painting',
                        'WoodworkPainting_AllottedConstructionStage',
                        'WoodworkPainting_PresentCompletion',
                        'WoodworkPainting_NoOfFloorsCompleted',
                        null),
                    TableRow(
                      children: [
                        _buildTableCell(const Text('')),
                        _buildTableCell(const Text('Total Completion', style: TextStyle(fontWeight: FontWeight.bold))),
                        _buildTableCell(TextField(
                          controller: controllers['TotalCompletion_AllottedConstructionStage'],
                          decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                        )),
                        _buildTableCell(TextField(
                          controller: controllers['TotalCompletion_PresentCompletion'],
                          decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                        )),
                        _buildTableCell(TextField(
                          controller: controllers['TotalCompletion_NoOfFloorsCompleted'],
                          decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                        )),
                        _buildTableCell(TextField(
                          controller: controllers['RecommendedAmountInPercent'],
                          decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                        )),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Section 8: DOCUMENTS AND PERMISSIONS
            ExpansionTile(
              title: const Text(
                "8. DOCUMENTS AND PERMISSIONS",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              children: [
                const SizedBox(height: 20),
                ...[
                  'Layout Plans Details',
                  'Building Plan Details',
                  'Construction Permission Number & Date/Commencement Certificate Details',
                  'Occupation/ Completion Certificate Details',
                  'Title Documents Verification Certificate',
                  'Latest Ownership Document with Address and Area under Transaction',
                  'Any Other Documents',
                  'Deviations Observed on Site with Approved Plan',
                  'If Approved Plans are not available, Construction done as per Local Bylaws',
                  'Permissible FSI',
                  'Is the Property Mortgaged or Disputed?',
                  'Value/ Purchase Price paid as per Sale Deed',
                  'Present Market Rate of the Property',
                  'Details of recent transaction in the neighborhood, if any',
                ].map(
                  (key) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TextField(
                      controller: controllers[key],
                      decoration: InputDecoration(
                        labelText: key,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Section 9: VALUATION REPORT
            ExpansionTile(
              title: const Text(
                "9. VALUATION REPORT",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              children: [
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'LAND',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Table(
                      border: TableBorder.all(),
                      columnWidths: const {
                        0: FlexColumnWidth(3),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(2),
                      },
                      children: [
                        TableRow(
                          children: [
                            _buildTableHeaderCell('Land Area (Cents)'),
                            _buildTableHeaderCell('As per Site'),
                            _buildTableHeaderCell('As per Plan'),
                            _buildTableHeaderCell('As per Legal Doc'),
                          ],
                        ),
                        TableRow(
                          children: [
                            _buildTableCell(const Text('')), // Empty cell for "Land Area (Cents)" row
                            _buildTableCell(TextField(
                              controller: controllers['Land Area (Cents)_AsPerSite'],
                              decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                            )),
                            _buildTableCell(TextField(
                              controller: controllers['Land Area (Cents)_AsPerPlan'],
                              decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                            )),
                            _buildTableCell(TextField(
                              controller: controllers['Land Area (Cents)_AsPerLegalDoc'],
                              decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                            )),
                          ],
                        ),
                        TableRow(
                          children: [
                            _buildTableCell(const Text('Undivided Share of Land (in Cents)')),
                            _buildTableCell(TextField(
                              controller: controllers['Undivided Share of Land (in Cents)'],
                              decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                            )),
                            _buildTableCell(Container()), // Empty cells
                            _buildTableCell(Container()),
                          ],
                        ),
                        TableRow(
                          children: [
                            _buildTableCell(const Text('Adopted Land Area (in Cents)')),
                            _buildTableCell(TextField(
                              controller: controllers['Adopted Land Area (in Cents)'],
                              decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            )),
                            _buildTableCell(Container()), // Empty cells
                            _buildTableCell(Container()),
                          ],
                        ),
                        TableRow(
                          children: [
                            _buildTableCell(const Text('Adopted Land Rate (in Rs./Cents)')),
                            _buildTableCell(TextField(
                              controller: controllers['Adopted Land Rate (in Rs./Cents)'],
                              decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            )),
                            _buildTableCell(Container()), // Empty cells
                            _buildTableCell(Container()),
                          ],
                        ),
                        TableRow(
                          children: [
                            _buildTableCell(const Text('Guideline Rate for Land')),
                            _buildTableCell(TextField(
                              controller: controllers['Guideline Rate for Land'],
                              decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                            )),
                            _buildTableCell(Container()), // Empty cells
                            _buildTableCell(Container()),
                          ],
                        ),
                        TableRow(
                          children: [
                            _buildTableCell(const Text('LAND VALUE: (in Rs.)', style: TextStyle(fontWeight: FontWeight.bold))),
                            _buildTableCell(TextField(
                              controller: controllers['LAND VALUE (in Rs.)'],
                              decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            )),
                            _buildTableCell(Container()), // Empty cells
                            _buildTableCell(Container()),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'BUILDING',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Table(
                      border: TableBorder.all(),
                      columnWidths: const {
                        0: FlexColumnWidth(1.5), // Floor
                        1: FlexColumnWidth(1.5), // Area As per Site
                        2: FlexColumnWidth(1.5), // Area As per Documents
                        3: FlexColumnWidth(1), // Deviation
                        4: FlexColumnWidth(1.5), // Adopted Built-up Area
                        5: FlexColumnWidth(1.5), // Adopted Construction Rate
                        6: FlexColumnWidth(1.5), // Replacement Cost
                      },
                      children: [
                        TableRow(
                          children: [
                            _buildTableHeaderCell('Floor', textAlign: TextAlign.start),
                            _buildTableHeaderCell('Area As per Site\n(in Sq Feet)'),
                            _buildTableHeaderCell('Area As per Documents\n(in Sq Feet)'),
                            _buildTableHeaderCell('Deviation'),
                            _buildTableHeaderCell('Adopted Built-up Area\n(in Sq Feet)'),
                            _buildTableHeaderCell('Adopted Construction Rate\n(in Rs/ Sq Feet)'),
                            _buildTableHeaderCell('Replacement Cost (in Rs.)'),
                          ],
                        ),
                        _buildBuildingInputRow('Basement Floor',
                            'Basement Floor_Area As per Site',
                            'Basement Floor_Area As per Documents',
                            'Basement Floor_Deviation',
                            'Basement Floor_Adopted Built-up Area',
                            'Basement Floor_Adopted Construction Rate',
                            'Basement Floor_Replacement Cost'),
                        _buildBuildingInputRow('Stilt Floor',
                            'Stilt Floor_Area As per Site',
                            'Stilt Floor_Area As per Documents',
                            'Stilt Floor_Deviation',
                            'Stilt Floor_Adopted Built-up Area',
                            'Stilt Floor_Adopted Construction Rate',
                            'Stilt Floor_Replacement Cost'),
                        _buildBuildingInputRow('Ground Floor',
                            'Ground Floor_Area As per Site',
                            'Ground Floor_Area As per Documents',
                            'Ground Floor_Deviation',
                            'Ground Floor_Adopted Built-up Area',
                            'Ground Floor_Adopted Construction Rate',
                            'Ground Floor_Replacement Cost'),
                        _buildBuildingInputRow('First Floor',
                            'First Floor_Area As per Site',
                            'First Floor_Area As per Documents',
                            'First Floor_Deviation',
                            'First Floor_Adopted Built-up Area',
                            'First Floor_Adopted Construction Rate',
                            'First Floor_Replacement Cost'),
                        _buildBuildingInputRow('Second Floor',
                            'Second Floor_Area As per Site',
                            'Second Floor_Area As per Documents',
                            'Second Floor_Deviation',
                            'Second Floor_Adopted Built-up Area',
                            'Second Floor_Adopted Construction Rate',
                            'Second Floor_Replacement Cost'),
                        _buildBuildingInputRow('Third Floor',
                            'Third Floor_Area As per Site',
                            'Third Floor_Area As per Documents',
                            'Third Floor_Deviation',
                            'Third Floor_Adopted Built-up Area',
                            'Third Floor_Adopted Construction Rate',
                            'Third Floor_Replacement Cost'),
                        _buildBuildingInputRow('Fourth Floor',
                            'Fourth Floor_Area As per Site',
                            'Fourth Floor_Area As per Documents',
                            'Fourth Floor_Deviation',
                            'Fourth Floor_Adopted Built-up Area',
                            'Fourth Floor_Adopted Construction Rate',
                            'Fourth Floor_Replacement Cost'),
                        _buildBuildingInputRow('Fifth Floor',
                            'Fifth Floor_Area As per Site',
                            'Fifth Floor_Area As per Documents',
                            'Fifth Floor_Deviation',
                            'Fifth Floor_Adopted Built-up Area',
                            'Fifth Floor_Adopted Construction Rate',
                            'Fifth Floor_Replacement Cost'),
                        _buildBuildingInputRow('Total',
                            'Total_Area As per Site',
                            'Total_Area As per Documents',
                            'Total_Deviation',
                            'Total_Adopted Built-up Area',
                            'Total_Adopted Construction Rate',
                            'Total_Replacement Cost', isTotalRow: true),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Table(
                      border: TableBorder.all(),
                      children: [
                        TableRow(
                          children: [
                            _buildTableCell(const Text('Depreciation %')),
                            _buildTableCell(TextField(
                              controller: controllers['Depreciation %'],
                              decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                            )),
                          ],
                        ),
                        TableRow(
                          children: [
                            _buildTableCell(const Text('Net Replacement Cost (in Rs.)', style: TextStyle(fontWeight: FontWeight.bold))),
                            _buildTableCell(TextField(
                              controller: controllers['Net Replacement Cost (in Rs.)'],
                              decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            )),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Table(
                      border: TableBorder.all(),
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(1),
                        4: FlexColumnWidth(2),
                        5: FlexColumnWidth(1),
                      },
                      children: [
                        TableRow(
                          children: [
                            _buildTableCell(const Text('No. of Car Parking')),
                            _buildTableCell(TextField(
                              controller: controllers['No. of Car Parking'],
                              decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                            )),
                            _buildTableCell(const Text('Value of Parking (in Rs.)')),
                            _buildTableCell(TextField(
                              controller: controllers['Value of Parking (in Rs.)'],
                              decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                            )),
                            _buildTableCell(const Text('Value of Other Amenities (in Rs.)')),
                            _buildTableCell(TextField(
                              controller: controllers['Value of Other Amenities (in Rs.)'],
                              decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                            )),
                          ],
                        ),
                        TableRow(
                          children: [
                            _buildTableCell(const Text('BUILDING VALUE / Insurable Value (in Rs.)', style: TextStyle(fontWeight: FontWeight.bold))),
                            _buildTableCell(Container()),
                            _buildTableCell(Container()),
                            _buildTableCell(Container()),
                            _buildTableCell(TextField(
                              controller: controllers['BUILDING VALUE / Insurable Value (in Rs.)'],
                              decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            )),
                            _buildTableCell(Container()),
                          ],
                        ),
                        TableRow(
                          children: [
                            _buildTableCell(const Text('Building Value as per Govt Guideline Rate (in Rs.)', style: TextStyle(fontWeight: FontWeight.bold))),
                            _buildTableCell(Container()),
                            _buildTableCell(Container()),
                            _buildTableCell(Container()),
                            _buildTableCell(TextField(
                              controller: controllers['Building Value as per Govt Guideline Rate (in Rs.)'],
                              decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            )),
                            _buildTableCell(Container()),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30), // Added spacing below Valuation Report

                // SECTION 9: FINAL VALUES (Flutter UI input fields)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    '9. FINAL VALUES',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                ...[
                  'Estimated Cost to Complete the Property (in Rs.)',
                  'Guideline Value (in Rs.)',
                  'Estimated Rental Value of Building',
                  'Market Value (in Rs.)',
                  'Market Value (in Words)',
                  'State the Source for Arriving at the Market Value',
                  'Realizable value (in Rs.)',
                  'Realizable value (%)',
                  'Forced Sale Value (in Rs.)',
                  'Forced Sale Value (%)',
                ].map(
                  (key) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TextField(
                      controller: controllers[key],
                      decoration: InputDecoration(
                        labelText: key,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // SECTION 11: Annexure I - Valuer confirmation in case of Construction Deviation
            ExpansionTile(
              title: const Text(
                "11. Annexure I - Valuer confirmation in case of Construction Deviation",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Addendum proposed to the Valuation report by Valuer for all cases with deviations in Security',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Table(
                  border: TableBorder.all(),
                  columnWidths: const {
                    0: FlexColumnWidth(0.5), // S No.
                    1: FlexColumnWidth(3), // Description
                    2: FlexColumnWidth(4), // Details
                  },
                  children: [
                    TableRow(
                      children: [
                        _buildTableHeaderCell('S No.'),
                        _buildTableHeaderCell('Description'),
                        _buildTableHeaderCell('Details'),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(const Text('1')),
                        _buildTableCell(const Text('Whether approved plan copy is available?')),
                        _buildTableCell(TextField(
                          controller: controllers['ConstructionDeviation_ApprovedPlanAvailable'],
                          decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                        )),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(const Text('1(a)')),
                        _buildTableCell(const Text('If Yes - What is the deviation on security property?')),
                        _buildTableCell(TextField(
                          controller: controllers['ConstructionDeviation_DeviationOnSecurityProperty'],
                          decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                        )),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(const Text('1(b)')),
                        _buildTableCell(const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('If no - whether the following additional documents are made available -', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('Property Tax paid receipts over the last 3-4 years to confirm payment of taxes.'),
                            Text('Latest land record availability in present owner\'s name.'),
                          ],
                        )),
                        _buildTableCell(Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: controllers['ConstructionDeviation_PropertyTaxPaidReceipts'],
                              decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                            ),
                            TextField(
                              controller: controllers['ConstructionDeviation_LatestLandRecordAvailability'],
                              decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                            ),
                          ],
                        )),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(const Text('2')),
                        _buildTableCell(const Text('FSI/RAR/FAR prescribed by the local Authority/Town planning')),
                        _buildTableCell(TextField(
                          controller: controllers['ConstructionDeviation_FSIRARFAR_LocalAuthority'],
                          decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                        )),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(const Text('3')),
                        _buildTableCell(const Text('Max deviation permitted from prescribed FSI/RAR/FAR')),
                        _buildTableCell(TextField(
                          controller: controllers['ConstructionDeviation_MaxDeviationPermitted'],
                          decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                        )),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(const Text('4')),
                        _buildTableCell(const Text('FSI/RAR/FAR of the security property as per the agreement')),
                        _buildTableCell(TextField(
                          controller: controllers['ConstructionDeviation_FSIRARFAR_Agreement'],
                          decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                        )),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(const Text('')),
                        _buildTableCell(const Text('FSI/RAR/FAR of the security property as confirmed by the valuer')),
                        _buildTableCell(TextField(
                          controller: controllers['ConstructionDeviation_FSIRARFAR_ValuerConfirmed'],
                          decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                        )),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(const Text('5')),
                        _buildTableCell(const Text('Whether property can be accepted as security for the loan\n(Views/Remarks)')),
                        _buildTableCell(TextField(
                          controller: controllers['ConstructionDeviation_PropertyAcceptedAsSecurity'],
                          decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.all(8)),
                        )),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controllers['ConstructionDeviation_HerebyConfirmCertify'],
                  decoration: const InputDecoration(
                    labelText: 'I hereby confirm/ certify that',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Location Input Fields and Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: TextField(
                controller: _latController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Latitude',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: TextField(
                controller: _lonController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Longitude',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get Location'),
            ),
            const SizedBox(height: 20),

            // SECTION 12: ATTACHMENTS (Renumbered to 12)
            ExpansionTile(
              title: const Text(
                "12. ATTACHMENTS",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              children: [
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.add_photo_alternate),
                  label: const Text('Add Photo from Gallery'),
                ),
                const SizedBox(height: 20),
                _images.isEmpty
                    ? const Text('No images selected.')
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: _images.length,
                        itemBuilder: (context, index) {
                          // Display image using Image.memory which works for web and mobile
                          return Stack(
                            children: [
                              FutureBuilder<Uint8List>(
                                future: _images[index].readAsBytes(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                                    return Image.memory(snapshot.data!, fit: BoxFit.cover);
                                  }
                                  return const CircularProgressIndicator(); // Or a placeholder
                                },
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.cancel, color: Colors.red),
                                  onPressed: () => _removeImage(index),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ],
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _generatePdf,
              child: const Text('Generate PDF'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoundaryRow(String direction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(direction, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: TextField(
                controller: controllers['Boundaries_${direction}_SiteVisit'],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: TextField(
                controller: controllers['Boundaries_${direction}_LegalDocuments'],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}