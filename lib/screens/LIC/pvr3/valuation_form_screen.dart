// lib/valuation_form_screen.dart
// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'valuation_data_model.dart';
import 'pdf_generator.dart';

class ValuationFormScreen extends StatefulWidget {
  const ValuationFormScreen({super.key});
  @override
  _ValuationFormScreenState createState() => _ValuationFormScreenState();
}

class _ValuationFormScreenState extends State<ValuationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  
  // --- STATE FOR DYNAMIC UI ---
  PropertyType _selectedPropertyType = PropertyType.House;
  final List<FloorData> _floors = [
    FloorData(name: 'GF', area: '676', marketRate: '1500', guidelineRate: '1500'),
    FloorData(name: 'FF', area: '716', marketRate: '1500', guidelineRate: '1500'),
  ];
  final List<ValuationImage> _valuationImages = [];

  // --- ALL CONTROLLERS ---
  final _fileNoCtrl = TextEditingController(text: '5002050002910');
  final _valuerNameCtrl = TextEditingController(text: 'VIGNESH S');
  final _valuerCodeCtrl = TextEditingController(text: 'TVV0001');
  final _appointingAuthorityCtrl = TextEditingController(text: 'LICHFL THIRUVANANTHAPURAM');
  DateTime _inspectionDate = DateTime(2025, 6, 5);
  final _reraNoCtrl = TextEditingController(text: 'NA');
  final _schemeCtrl = TextEditingController(text: 'Purchase/ Renovation /Griha Vikas');
  final _applicantNameCtrl = TextEditingController(text: 'NARAYANAN GANESH KUMAR');
  final _documentPerusedCtrl = TextEditingController(text: 'Minor');
  final _addressCtrl = TextEditingController(text: '118 ARES RS NO 2100 A 1 DOOR NO 79 2290 MUTTATHARA VILLAGE...');
  bool _locationSketchVerified = true;
  final _northBoundaryCtrl = TextEditingController(text: 'PRIVATE ROAD HAVING CAR ACCESS');
  final _northDimCtrl = TextEditingController(text: '1000 CM');
  final _southBoundaryCtrl = TextEditingController(text: 'PROPERTY OF KRISHNAMMA');
  final _southDimCtrl = TextEditingController(text: '1000 CM');
  final _eastBoundaryCtrl = TextEditingController(text: 'PROPERTY OF MOHANASUNDARAM');
  final _eastDimCtrl = TextEditingController(text: '1581 CM');
  final _westBoundaryCtrl = TextEditingController(text: 'PROPERTY OF RADHIKA');
  final _westDimCtrl = TextEditingController(text: '891 CM');
  final _extent1Ctrl = TextEditingController(text: '1.18');
  final _extent2Ctrl = TextEditingController(text: '2.91');
  final _propertyTypeCtrl = TextEditingController(text: 'Bunglow');
  OccupantStatus _occupantStatus = OccupantStatus.Occupied;
  final _occupantNameCtrl = TextEditingController(text: 'RENTED');
  final _usageOfBuildingCtrl = TextEditingController(text: 'RESIDENTIAL');
  final _nearbyLandmarkCtrl = TextEditingController(text: 'SREEVARAHAM MARKET JUNCTION AND MANSIONS SREENIDHI');
  final _surroundingAreaDevCtrl = TextEditingController(text: 'Middle Class');
  bool _basicAmenitiesAvailable = true;
  final _negativesToLocalityCtrl = TextEditingController(text: 'NIL');
  final _favourableConsiderationsCtrl = TextEditingController(text: 'NIL');
  final _otherFeaturesCtrl = TextEditingController(text: 'NIL');
  bool _approvedDrawingAvailable = true;
  final _approvalNoAndDateCtrl = TextEditingController(text: 'FE2/TSL/28/11 25-04-11');
  bool _constructionAsPerPlan = true;
  final _drawingDeviationsCtrl = TextEditingController(text: 'NIL');
  DeviationNature _deviationNature = DeviationNature.Minor;
  final _marketabilityCtrl = TextEditingController(text: 'Good');
  final _buildingAgeCtrl = TextEditingController(text: '13');
  final _residualLifeCtrl = TextEditingController(text: '37');
  final _fsiApprovedCtrl = TextEditingController(text: '1.1');
  final _fsiActualCtrl = TextEditingController(text: '1.1');
  final _specFoundationCtrl = TextEditingController(text: 'RR MASONRY');
  final _specRoofCtrl = TextEditingController(text: 'RCC');
  final _specFlooringCtrl = TextEditingController(text: 'VITRIFIED TILES');
  final _qualityOfConstructionCtrl = TextEditingController(text: 'GOOD');
  bool _adheresToSafetySpecs = true;
  bool _highTensionLineImpact = false;
  final _landAreaCtrl = TextEditingController(text: '2.91');
  final _landUnitRateCtrl = TextEditingController(text: '1200000');
  final _landGuidelineRateCtrl = TextEditingController(text: '1141140');
  final _amenitiesAreaCtrl = TextEditingController(text: '0');
  final _amenitiesUnitRateCtrl = TextEditingController(text: '0');
  final _amenitiesGuidelineRateCtrl = TextEditingController(text: '0');
  final _marketValueSourceHouseCtrl = TextEditingController(text: 'LOCAL MARKET ENQUIRY');
  final _flatUndividedShareCtrl = TextEditingController(text: 'NA');
  final _flatBuiltUpAreaCtrl = TextEditingController(text: '0');
  final _flatCompositeRateCtrl = TextEditingController(text: '0');
  final _flatValueUnitRateCtrl = TextEditingController(text: '0');
  final _flatValueMarketCtrl = TextEditingController(text: '0');
  final _flatValueGuidelineRateCtrl = TextEditingController(text: '0');
  final _flatValueGuidelineCtrl = TextEditingController(text: '0');
  final _marketValueSourceFlatCtrl = TextEditingController(text: 'NA');
  final _flatExtraAmenitiesCtrl = TextEditingController(text: '0');
  final _improvementDescriptionCtrl = TextEditingController(text: 'FLOORING PAINTING SHEET ROOFING...');
  final _improvementAmountCtrl = TextEditingController(text: '2000000');
  bool _improvementEstimateReasonable = true;
  final _improvementCompletedValueCtrl = TextEditingController(text: '2000000');
  final _remarksBackgroundCtrl = TextEditingController(text: 'SUBMITTED DOCUMENTS');
  final _remarksSourcesCtrl = TextEditingController(text: 'LOCAL MARKET ENQUIRY');
  final _remarksProceduresCtrl = TextEditingController(text: 'MARKET APPROACH');
  final _remarksMethodologyCtrl = TextEditingController(text: 'COMPARISON METHOD');
  final _remarksFactorsCtrl = TextEditingController(text: 'AMENITIES AND ACCESSIBILITY');

  void _addFloor() => setState(() => _floors.add(FloorData(name: 'New Floor')));
  void _removeFloor(int index) {
    if (_floors.length > 1) {
      setState(() => _floors.removeAt(index));
    }
  }

  Future<void> _getCurrentLocation(int imageIndex) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Location services are disabled.")));
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Location permissions are denied.")));
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Location permissions are permanently denied.")));
      return;
    }
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _valuationImages[imageIndex].latitude = position.latitude.toString();
        _valuationImages[imageIndex].longitude = position.longitude.toString();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error getting location: $e")));
    }
  }

  // Inside _ValuationFormScreenPVR1State

Future<void> _pickImage(ImageSource source) async {
  try {
    if (source == ImageSource.gallery) {
      final pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        for (var file in pickedFiles) {
          final bytes = await file.readAsBytes();
          _valuationImages.add(ValuationImage(imageFile: bytes));
        }
        setState(() {}); 
      }
    } else {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _valuationImages.add(ValuationImage(imageFile: bytes));
        });
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to pick images: $e')),
    );
  }
}

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(child: Wrap(children: <Widget>[
          ListTile(leading: const Icon(Icons.photo_library), title: const Text('Photo Library'), onTap: () { _pickImage(ImageSource.gallery); Navigator.of(context).pop(); }),
          ListTile(leading: const Icon(Icons.photo_camera), title: const Text('Camera'), onTap: () { _pickImage(ImageSource.camera); Navigator.of(context).pop(); }),
        ]));
      },
    );
  }
  
  void _generatePdf() {
    if (_formKey.currentState!.validate()) {
      final data = ValuationData(
        fileNo: _fileNoCtrl.text, valuerName: _valuerNameCtrl.text, valuerCode: _valuerCodeCtrl.text, appointingAuthority: _appointingAuthorityCtrl.text, inspectionDate: _inspectionDate, reraNo: _reraNoCtrl.text, scheme: _schemeCtrl.text,
        applicantName: _applicantNameCtrl.text, documentPerused: _documentPerusedCtrl.text, propertyAddress: _addressCtrl.text, locationSketchVerified: _locationSketchVerified,
        northBoundary: _northBoundaryCtrl.text, southBoundary: _southBoundaryCtrl.text, eastBoundary: _eastBoundaryCtrl.text, westBoundary: _westBoundaryCtrl.text,
        northDim: _northDimCtrl.text, southDim: _southDimCtrl.text, eastDim: _eastDimCtrl.text, westDim: _westDimCtrl.text,
        extent1: _extent1Ctrl.text, extent2: _extent2Ctrl.text, propertyType: _propertyTypeCtrl.text, occupantStatus: _occupantStatus, occupantName: _occupantNameCtrl.text, usageOfBuilding: _usageOfBuildingCtrl.text,
        nearbyLandmark: _nearbyLandmarkCtrl.text, surroundingAreaDev: _surroundingAreaDevCtrl.text, basicAmenitiesAvailable: _basicAmenitiesAvailable,
        negativesToLocality: _negativesToLocalityCtrl.text, favourableConsiderations: _favourableConsiderationsCtrl.text, otherFeatures: _otherFeaturesCtrl.text,
        approvedDrawingAvailable: _approvedDrawingAvailable, approvalNoAndDate: _approvalNoAndDateCtrl.text, constructionAsPerPlan: _constructionAsPerPlan,
        drawingDeviations: _drawingDeviationsCtrl.text, deviationNature: _deviationNature,
        marketability: _marketabilityCtrl.text, buildingAge: _buildingAgeCtrl.text, residualLife: _residualLifeCtrl.text,
        fsiApproved: _fsiApprovedCtrl.text, fsiActual: _fsiActualCtrl.text,
        specFoundation: _specFoundationCtrl.text, specRoof: _specRoofCtrl.text, specFlooring: _specFlooringCtrl.text,
        qualityOfConstruction: _qualityOfConstructionCtrl.text, adheresToSafetySpecs: _adheresToSafetySpecs, highTensionLineImpact: _highTensionLineImpact,
        valuationType: _selectedPropertyType,
        landArea: _landAreaCtrl.text, landUnitRate: _landUnitRateCtrl.text, landGuidelineRate: _landGuidelineRateCtrl.text,
        floors: _floors,
        amenitiesArea: _amenitiesAreaCtrl.text, amenitiesUnitRate: _amenitiesUnitRateCtrl.text, amenitiesGuidelineRate: _amenitiesGuidelineRateCtrl.text,
        marketValueSourceHouse: _marketValueSourceHouseCtrl.text,
        flatUndividedShare: _flatUndividedShareCtrl.text, flatBuiltUpArea: _flatBuiltUpAreaCtrl.text, flatCompositeRate: _flatCompositeRateCtrl.text,
        flatValueUnitRate: _flatValueUnitRateCtrl.text, flatValueMarket: _flatValueMarketCtrl.text, flatValueGuideline: _flatValueGuidelineCtrl.text, flatValueGuidelineRate: _flatValueGuidelineRateCtrl.text,
        marketValueSourceFlat: _marketValueSourceFlatCtrl.text, flatExtraAmenities: _flatExtraAmenitiesCtrl.text,
        improvementDescription: _improvementDescriptionCtrl.text, improvementAmount: _improvementAmountCtrl.text, improvementEstimateReasonable: _improvementEstimateReasonable,
        improvementCompletedValue: _improvementCompletedValueCtrl.text,
        remarksBackground: _remarksBackgroundCtrl.text, remarksSources: _remarksSourcesCtrl.text, remarksProcedures: _remarksProceduresCtrl.text, remarksMethodology: _remarksMethodologyCtrl.text, remarksFactors: _remarksFactorsCtrl.text,
        images: _valuationImages,
      );
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => PreviewScreen(data: data)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PVR-3 Dynamic Report')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSection(title: 'Header Information', children: [
              TextFormField(controller: _fileNoCtrl, decoration: const InputDecoration(labelText: 'File No.')),
              TextFormField(controller: _valuerNameCtrl, decoration: const InputDecoration(labelText: 'Valuer Name')),
              TextFormField(controller: _valuerCodeCtrl, decoration: const InputDecoration(labelText: 'Valuer Code')),
              TextFormField(controller: _appointingAuthorityCtrl, decoration: const InputDecoration(labelText: 'Appointing Authority')),
              TextFormField(controller: _reraNoCtrl, decoration: const InputDecoration(labelText: 'RERA NO.')),
              TextFormField(controller: _schemeCtrl, decoration: const InputDecoration(labelText: 'Scheme')),
              ListTile(contentPadding: EdgeInsets.zero, title: const Text("Inspection Date"), subtitle: Text(DateFormat('dd-MM-yyyy').format(_inspectionDate)), trailing: const Icon(Icons.calendar_today), onTap: () async { final picked = await showDatePicker(context: context, initialDate: _inspectionDate, firstDate: DateTime(2000), lastDate: DateTime(2100)); if (picked != null) setState(() => _inspectionDate = picked); }),
            ]),
            _buildSection(title: '1. Property Details', children: [
              TextFormField(controller: _applicantNameCtrl, decoration: const InputDecoration(labelText: 'Applicant Name')),
              TextFormField(controller: _documentPerusedCtrl, decoration: const InputDecoration(labelText: 'Document Perused')),
              TextFormField(controller: _addressCtrl, decoration: const InputDecoration(labelText: 'Property Address'), maxLines: 3),
              SwitchListTile(title: const Text('Location Sketch Verified'), value: _locationSketchVerified, onChanged: (v) => setState(() => _locationSketchVerified = v)),
              TextFormField(controller: _propertyTypeCtrl, decoration: const InputDecoration(labelText: 'Type of property')),
              DropdownButtonFormField<OccupantStatus>(value: _occupantStatus, decoration: const InputDecoration(labelText: 'Occupant Status'), items: OccupantStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.name))).toList(), onChanged: (v) => setState(() => _occupantStatus = v!)),
              TextFormField(controller: _occupantNameCtrl, decoration: InputDecoration(labelText: _occupantStatus == OccupantStatus.Occupied ? 'Name of Occupant' : 'List of Occupants')),
              TextFormField(controller: _usageOfBuildingCtrl, decoration: const InputDecoration(labelText: 'Usage of Building')),
              TextFormField(controller: _nearbyLandmarkCtrl, decoration: const InputDecoration(labelText: 'Nearby Landmark')),
              TextFormField(controller: _surroundingAreaDevCtrl, decoration: const InputDecoration(labelText: 'Development of surrounding area')),
              SwitchListTile(title: const Text('Basic amenities available'), value: _basicAmenitiesAvailable, onChanged: (v) => setState(() => _basicAmenitiesAvailable = v)),
              TextFormField(controller: _negativesToLocalityCtrl, decoration: const InputDecoration(labelText: 'Negatives to the locality')),
              TextFormField(controller: _favourableConsiderationsCtrl, decoration: const InputDecoration(labelText: 'Favourable considerations')),
              TextFormField(controller: _otherFeaturesCtrl, decoration: const InputDecoration(labelText: 'Other features')),
            ]),
            _buildSection(title: '2. Drawing', children: [
              SwitchListTile(title: const Text('Approved Drawing Available'), value: _approvedDrawingAvailable, onChanged: (v) => setState(() => _approvedDrawingAvailable = v)),
              TextFormField(controller: _approvalNoAndDateCtrl, decoration: const InputDecoration(labelText: 'Approval No. & Date')),
              SwitchListTile(title: const Text('Construction as per plan'), value: _constructionAsPerPlan, onChanged: (v) => setState(() => _constructionAsPerPlan = v)),
              TextFormField(controller: _drawingDeviationsCtrl, decoration: const InputDecoration(labelText: 'Deviations between drawing & actual')),
              DropdownButtonFormField<DeviationNature>(value: _deviationNature, decoration: const InputDecoration(labelText: 'Deviation Nature'), items: DeviationNature.values.map((d) => DropdownMenuItem(value: d, child: Text(d.name))).toList(), onChanged: (v) => setState(() => _deviationNature = v!)),
            ]),
            _buildSection(title: '3. Building Details', children: [
              TextFormField(controller: _marketabilityCtrl, decoration: const InputDecoration(labelText: 'Marketability')),
              TextFormField(controller: _buildingAgeCtrl, decoration: const InputDecoration(labelText: 'Age of Building'), keyboardType: TextInputType.number),
              TextFormField(controller: _residualLifeCtrl, decoration: const InputDecoration(labelText: 'Future Residual Life'), keyboardType: TextInputType.number),
              TextFormField(controller: _fsiApprovedCtrl, decoration: const InputDecoration(labelText: 'FSI (Approved)')),
              TextFormField(controller: _fsiActualCtrl, decoration: const InputDecoration(labelText: 'FSI (Actual)')),
              TextFormField(controller: _specFoundationCtrl, decoration: const InputDecoration(labelText: 'Specification: Foundation')),
              TextFormField(controller: _specRoofCtrl, decoration: const InputDecoration(labelText: 'Specification: Roof')),
              TextFormField(controller: _specFlooringCtrl, decoration: const InputDecoration(labelText: 'Specification: Flooring')),
              TextFormField(controller: _qualityOfConstructionCtrl, decoration: const InputDecoration(labelText: 'Quality of Construction')),
              SwitchListTile(title: const Text('Adheres to Safety Specs (NBC/NDMA)'), value: _adheresToSafetySpecs, onChanged: (v) => setState(() => _adheresToSafetySpecs = v)),
              SwitchListTile(title: const Text('Adverse Impact from High Tension Lines'), value: _highTensionLineImpact, onChanged: (v) => setState(() => _highTensionLineImpact = v)),
            ]),
            _buildSection(title: '4. Valuation Details', initiallyExpanded: true, children: [
              Text('Select Property Type:', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              Row(children: [
                Expanded(child: RadioListTile<PropertyType>(title: const Text('House'), value: PropertyType.House, groupValue: _selectedPropertyType, onChanged: (v) => setState(() => _selectedPropertyType = v!))),
                Expanded(child: RadioListTile<PropertyType>(title: const Text('Flat'), value: PropertyType.Flat, groupValue: _selectedPropertyType, onChanged: (v) => setState(() => _selectedPropertyType = v!))),
              ]),
              const Divider(height: 20),
              if (_selectedPropertyType == PropertyType.House) _buildHouseValuationUI() else _buildFlatValuationUI(),
            ]),
            _buildSection(title: '5. Estimate for Improvement', children: [
               TextFormField(controller: _improvementDescriptionCtrl, decoration: const InputDecoration(labelText: 'Description of Improvement Works'), maxLines: 2),
               TextFormField(controller: _improvementAmountCtrl, decoration: const InputDecoration(labelText: 'Amount Estimated by Applicant'), keyboardType: TextInputType.number),
               SwitchListTile(title: const Text('Is the estimate reasonable?'), value: _improvementEstimateReasonable, onChanged: (v) => setState(() => _improvementEstimateReasonable = v)),
            ]),
            _buildSection(title: '6. Progress of Work', children: [
                TextFormField(controller: _improvementCompletedValueCtrl, decoration: const InputDecoration(labelText: 'Value of Improvement Works Completed'), keyboardType: TextInputType.number),
            ]),
            _buildSection(title: '8. Remarks', children: [
                TextFormField(controller: _remarksBackgroundCtrl, decoration: const InputDecoration(labelText: 'a) Background information')),
                TextFormField(controller: _remarksSourcesCtrl, decoration: const InputDecoration(labelText: 'b) Sources of information')),
                TextFormField(controller: _remarksProceduresCtrl, decoration: const InputDecoration(labelText: 'c) Procedures adopted')),
                TextFormField(controller: _remarksMethodologyCtrl, decoration: const InputDecoration(labelText: 'd) Valuation methodology')),
                TextFormField(controller: _remarksFactorsCtrl, decoration: const InputDecoration(labelText: 'e) Major factors that influenced')),
            ]),
            _buildSection(title: "Images & Location", initiallyExpanded: true, children: [
              Center(child: ElevatedButton.icon(icon: const Icon(Icons.add_a_photo), label: const Text('Add Images'), onPressed: _showImagePickerOptions)),
              if (_valuationImages.isNotEmpty) ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _valuationImages.length,
                itemBuilder: (context, index) {
                  final valuationImage = _valuationImages[index];
                  final latController = TextEditingController(text: valuationImage.latitude);
                  final lonController = TextEditingController(text: valuationImage.longitude);
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(padding: const EdgeInsets.all(8.0), child: Column(children: [
                      Stack(children: [
                        Image.memory(valuationImage.imageFile, height: 150, width: double.infinity, fit: BoxFit.cover),
                        Positioned(right: 0, top: 0, child: CircleAvatar(radius: 18, backgroundColor: Colors.white70, child: IconButton(padding: EdgeInsets.zero, icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => _valuationImages.removeAt(index))))),
                      ]),
                      const SizedBox(height: 10),
                      Row(children: [
                        Expanded(child: TextFormField(controller: latController, decoration: const InputDecoration(labelText: 'Latitude', border: OutlineInputBorder()), onChanged: (value) => valuationImage.latitude = value)),
                        const SizedBox(width: 10),
                        Expanded(child: TextFormField(controller: lonController, decoration: const InputDecoration(labelText: 'Longitude', border: OutlineInputBorder()), onChanged: (value) => valuationImage.longitude = value)),
                      ]),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(icon: const Icon(Icons.my_location), label: const Text('Get Current Location'), onPressed: () => _getCurrentLocation(index)),
                    ])),
                  );
                },
              ),
            ]),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(icon: const Icon(Icons.picture_as_pdf), label: const Text('Generate PDF'), onPressed: _generatePdf),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children, bool initiallyExpanded = false}) => Card(
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: ExpansionTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      initiallyExpanded: initiallyExpanded,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: children.map((child) => Padding(padding: const EdgeInsets.only(bottom: 12), child: child)).toList(),
    ),
  );

  Widget _buildHouseValuationUI() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('a. Value of the property (if it is a house)', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 8),
      Text('Land Details', style: Theme.of(context).textTheme.titleSmall),
      TextFormField(controller: _landAreaCtrl, decoration: const InputDecoration(labelText: 'Land Area')),
      TextFormField(controller: _landUnitRateCtrl, decoration: const InputDecoration(labelText: 'Land Unit Rate (Market)')),
      TextFormField(controller: _landGuidelineRateCtrl, decoration: const InputDecoration(labelText: 'Land Unit Rate (Guideline)')),
      const Divider(height: 20, thickness: 1),
      Text('Floor Details', style: Theme.of(context).textTheme.titleSmall),
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _floors.length,
        itemBuilder: (context, index) => _buildFloorInputRow(index),
      ),
      Align(alignment: Alignment.centerRight, child: TextButton.icon(icon: const Icon(Icons.add_circle), label: const Text('Add Floor'), onPressed: _addFloor)),
      const Divider(height: 20, thickness: 1),
      Text('Amenities', style: Theme.of(context).textTheme.titleSmall),
      TextFormField(controller: _amenitiesAreaCtrl, decoration: const InputDecoration(labelText: 'Amenities Area')),
      TextFormField(controller: _amenitiesUnitRateCtrl, decoration: const InputDecoration(labelText: 'Amenities Unit Rate (Market)')),
      TextFormField(controller: _amenitiesGuidelineRateCtrl, decoration: const InputDecoration(labelText: 'Amenities Unit Rate (Guideline)')),
      const Divider(height: 20, thickness: 1),
      TextFormField(controller: _marketValueSourceHouseCtrl, decoration: const InputDecoration(labelText: 'Source for Market Value')),
    ],
  );

  Widget _buildFloorInputRow(int index) {
    final floor = _floors[index];
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(children: [
              Expanded(flex: 3, child: TextFormField(initialValue: floor.name, decoration: const InputDecoration(labelText: 'Floor Name'), onChanged: (value) => floor.name = value)),
              if (_floors.length > 1) IconButton(icon: const Icon(Icons.remove_circle_outline, color: Colors.red), onPressed: () => _removeFloor(index))
            ]),
            TextFormField(initialValue: floor.area, decoration: const InputDecoration(labelText: 'Area'), onChanged: (value) => floor.area = value, keyboardType: TextInputType.number),
            TextFormField(initialValue: floor.marketRate, decoration: const InputDecoration(labelText: 'Market Rate'), onChanged: (value) => floor.marketRate = value, keyboardType: TextInputType.number),
            TextFormField(initialValue: floor.guidelineRate, decoration: const InputDecoration(labelText: 'Guideline Rate'), onChanged: (value) => floor.guidelineRate = value, keyboardType: TextInputType.number),
          ],
        ),
      ),
    );
  }

  Widget _buildFlatValuationUI() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('b. Value of the property (if it is a flat)', style: Theme.of(context).textTheme.titleMedium),
      TextFormField(controller: _flatUndividedShareCtrl, decoration: const InputDecoration(labelText: '1. Undivided Share of Land')),
      TextFormField(controller: _flatBuiltUpAreaCtrl, decoration: const InputDecoration(labelText: '2. Built Up Area of the Flat')),
      TextFormField(controller: _flatCompositeRateCtrl, decoration: const InputDecoration(labelText: '3. Adopted unit composite Rate')),
      const SizedBox(height: 10),
      Text('4. Estimated Value of the Flat', style: Theme.of(context).textTheme.bodyLarge),
      Row(children: [
        Expanded(child: TextFormField(controller: _flatValueUnitRateCtrl, decoration: const InputDecoration(labelText: 'Unit Rate'))),
        const SizedBox(width: 8),
        Expanded(child: TextFormField(controller: _flatValueMarketCtrl, decoration: const InputDecoration(labelText: 'Market Value'))),
      ]),
      Row(children: [
        Expanded(child: TextFormField(controller: _flatValueGuidelineRateCtrl, decoration: const InputDecoration(labelText: 'Guideline Rate'))),
        const SizedBox(width: 8),
        Expanded(child: TextFormField(controller: _flatValueGuidelineCtrl, decoration: const InputDecoration(labelText: 'Guideline Value'))),
      ]),
      const SizedBox(height: 10),
      TextFormField(controller: _marketValueSourceFlatCtrl, decoration: const InputDecoration(labelText: 'e. State the source for arriving at the Market Value')),
      TextFormField(controller: _flatExtraAmenitiesCtrl, decoration: const InputDecoration(labelText: 'f. Add for extra amenities if any')),
    ],
  );
}

class PreviewScreen extends StatelessWidget {
  final ValuationData data;
  const PreviewScreen({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Preview')),
      body: PdfPreview(
        build: (format) => generateValuationPdf(data),
        canChangeOrientation: false,
        canDebug: false,
      ),
    );
  }
}