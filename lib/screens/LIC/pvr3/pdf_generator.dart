// lib/pdf_generator.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'valuation_data_model.dart';

Future<Uint8List> generateValuationPdf(ValuationData data) async {
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

  pdf.addPage(_buildPage1(data));
  pdf.addPage(_buildPage2(data));

  if (data.images.isNotEmpty) {
    pdf.addPage(_buildImagePage(data));
  }

  return pdf.save();
}

// --- PAGE 1 BUILDER ---
pw.Page _buildPage1(ValuationData data) {
  final dateFormat = DateFormat('dd-MM-yyyy');
  return pw.Page(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.all(36),
    build: (context) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildInfoTable(data, dateFormat),
          pw.SizedBox(height: 10),
          _buildSectionHeader('1. PROPERTY DETAILS:'),
          _buildPropertyDetails(data),
          _buildSectionHeader('2. DRAWING'),
          _buildDrawingDetails(data),
          pw.SizedBox(height: 10),
        ],
      );
    },
  );
}

// --- PAGE 2 BUILDER ---
pw.Page _buildPage2(ValuationData data) {
  final currencyFormat =
      NumberFormat.currency(locale: 'en_IN', symbol: 'Rs. ', decimalDigits: 0);

  return pw.Page(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.all(36),
    build: (context) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('3. Building Details'),
          _buildBuildingDetails(data),
          pw.SizedBox(height: 10),
          _buildSectionHeader('4. VALUATION DETAILS:'),
          pw.Text(
              '(Exclude the value of items for which the estimate... have been submitted by the applicant)',
              style: const pw.TextStyle(fontSize: 8)),
          pw.SizedBox(height: 5),
          if (data.valuationType == PropertyType.House)
            _buildHouseValuationPdf(data, currencyFormat)
          else
            _buildFlatValuationPdf(data, currencyFormat),
          pw.SizedBox(height: 10),
          _buildSectionHeader('5. ESTIMATE FOR IMPROVEMENT (If applicable)'),
          _buildImprovementDetails(data, currencyFormat),
          pw.SizedBox(height: 10),
          _buildSectionHeader('6. PROGRESS OF WORK (If applicable)'),
          _buildProgressOfWorkTable(data),
          pw.SizedBox(height: 10),
          _buildSectionHeader('8. Remarks If Any'),
          _buildRemarks(data),
          pw.Spacer(),
          pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text('SIGNATURE OF THE VALUER',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 10))),
        ],
      );
    },
  );
}

// --- IMAGE PAGE BUILDER ---
pw.MultiPage _buildImagePage(ValuationData data) {
  return pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.all(36),
    header: (context) => pw.Text('Uploaded Images',
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
    build: (context) => [
      pw.GridView(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        children: data.images.map((valuationImage) {
          final image =
              pw.MemoryImage(valuationImage.imageFile.readAsBytesSync());
          return pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                    child: pw.SizedBox(
                        width: double.infinity,
                        child: pw.Image(image, fit: pw.BoxFit.contain))),
                pw.SizedBox(height: 5),
                pw.Text(
                    '(Latitude): ${valuationImage.latitude}\n(Longitude): ${valuationImage.longitude}',
                    style: const pw.TextStyle(fontSize: 8)),
              ],
            ),
          );
        }).toList(),
      ),
    ],
  );
}

// --- HELPER WIDGETS FOR BUILDING PDF SECTIONS ---

pw.Widget _buildHeader() => pw.Column(children: [
      pw.Stack(children: [
        pw.Center(
            child: pw.Column(children: [
          pw.Text('LIC HOUSING FINANCE LIMITED',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text('AREA OFFICE: THIRUVANANTHAPURAM'),
          pw.SizedBox(height: 5),
          pw.Text('VALUATION REPORT BY PANEL VALUER FOR HOME LOAN',
              style: const pw.TextStyle(decoration: pw.TextDecoration.underline)),
        ])),
        pw.Align(
            alignment: pw.Alignment.topRight,
            child: pw.Text('PVR-3',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
      ]),
      pw.SizedBox(height: 15),
    ]);

pw.Table _buildInfoTable(ValuationData data, DateFormat dateFormat) => pw.Table(
      columnWidths: {
        0: const pw.FlexColumnWidth(1),
        1: const pw.FlexColumnWidth(2)
      },
      children: [
        pw.TableRow(
            children: [pw.Text(' * File no.'), pw.Text(': ${data.fileNo}')]),
        pw.TableRow(children: [
          pw.Text(' * Name of the Valuer'),
          pw.Text(': ${data.valuerName} (${data.valuerCode})')
        ]),
        pw.TableRow(children: [
          pw.Text(' Appointing Authority'),
          pw.Text(': ${data.appointingAuthority}')
        ]),
        pw.TableRow(children: [
          pw.Text(' Date of Inspection'),
          pw.Text(': ${dateFormat.format(data.inspectionDate)}')
        ]),
        pw.TableRow(children: [
          pw.Text(' RERA NO. (For Flats)'),
          pw.Text(': ${data.reraNo}')
        ]),
      ],
    );

pw.Widget _buildPropertyDetails(ValuationData data) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildKeyValue('a. * Name of the Applicant', data.applicantName),
        _buildKeyValue('b. Document perused', data.documentPerused),
        _buildKeyValue(
            'c. * Location of the Property...', data.propertyAddress),
        _buildKeyBoolValue(
            'd. Location Sketch verified', data.locationSketchVerified),
        pw.SizedBox(height: 5),
        pw.Text('e. Boundaries and Dimensions',
            style: const pw.TextStyle(
                fontSize: 10, decoration: pw.TextDecoration.underline)),
        pw.TableHelper.fromTextArray(
          border: pw.TableBorder.all(width: 0.5),
          headerStyle:
              pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
          cellStyle: const pw.TextStyle(fontSize: 9),
          headers: [' ', 'Boundaries', 'Dimensions'],
          data: [
            ['North/Front', data.northBoundary, data.northDim],
            ['South/Rear', data.southBoundary, data.southDim],
            ['East/Left(side 1)', data.eastBoundary, data.eastDim],
            ['West/Right(side 2)', data.westBoundary, data.westDim],
            ['Extent', data.extent1, data.extent2],
          ],
        ),
        pw.SizedBox(height: 5),
        _buildKeyValue('f. Type of the property', data.propertyType),
        _buildKeyValue('g. Occupant', data.occupantName),
        _buildKeyValue('h. Usage of the Building', data.usageOfBuilding),
        _buildKeyValue(
            'i. Details of the Nearby Landmark', data.nearbyLandmark),
        _buildKeyValue(
            'j. Development of surrounding area...', data.surroundingAreaDev),
        _buildKeyBoolValue('k. Whether basic amenities... are available',
            data.basicAmenitiesAvailable),
        _buildKeyValue(
            'l. Any negatives to the locality', data.negativesToLocality),
        _buildKeyValue(
            'm. Any favourable considerations', data.favourableConsiderations),
        _buildKeyValue('n. Any other features', data.otherFeatures),
      ],
    );

pw.Widget _buildDrawingDetails(ValuationData data) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildKeyBoolValue('a. Whether the approved drawing is available?',
            data.approvedDrawingAvailable),
        _buildKeyValue('b. Approval No. & date', data.approvalNoAndDate),
        _buildKeyBoolValue(
            'c. Whether the construction is as per approved plan(Yes/No)',
            data.constructionAsPerPlan),
        _buildKeyValue(
            'd. What are the deviations between approved drawing & actual?',
            data.drawingDeviations),
        _buildKeyValue('e. Whether deviations are minor/major in nature',
            data.deviationNature.name),
      ],
    );

pw.Widget _buildBuildingDetails(ValuationData data) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildKeyValue('1. Marketability of the Property', data.marketability),
        _buildKeyValue('2. Age of the Building', data.buildingAge),
        _buildKeyValue('3. Future Residual life expected', data.residualLife),
        pw.Table(
          border: pw.TableBorder.all(width: 0.5),
          columnWidths: {
            0: const pw.FlexColumnWidth(4),
            1: const pw.FlexColumnWidth(2),
            2: const pw.FlexColumnWidth(2)
          },
          children: [
            pw.TableRow(children: [
              pw.Padding(
                  padding: const pw.EdgeInsets.all(2),
                  child: pw.Text('4. Floor Space Index')),
              pw.Center(child: pw.Text('As per Approved Plan/as per rule')),
              pw.Center(child: pw.Text('Actual')),
            ]),
            pw.TableRow(children: [
              pw.Container(),
              pw.Center(child: pw.Text(data.fsiApproved)),
              pw.Center(child: pw.Text(data.fsiActual)),
            ]),
          ],
        ),
        _buildKeyValue('5. Specification', ''),
        _buildKeyValue('    Foundation', data.specFoundation, isSubItem: true),
        _buildKeyValue('    Roof', data.specRoof, isSubItem: true),
        _buildKeyValue('    Flooring', data.specFlooring, isSubItem: true),
        _buildKeyValue('6. Quality of Construction (Exterior & Interior)',
            data.qualityOfConstruction),
        _buildKeyBoolValue(
            '7. i) Adheres to Safety Specs...', data.adheresToSafetySpecs),
        _buildKeyBoolValue(
            '8. High Tension Wire Lines Impact...', data.highTensionLineImpact),
      ],
    );

pw.Widget _buildHouseValuationPdf(
    ValuationData data, NumberFormat currencyFormat) {
  final List<List<String>> floorRows = data.floors.map((floor) {
    final marketValue = (double.tryParse(floor.area) ?? 0) *
        (double.tryParse(floor.marketRate) ?? 0);
    final guidelineValue = (double.tryParse(floor.area) ?? 0) *
        (double.tryParse(floor.guidelineRate) ?? 0);
    return [
      floor.name,
      floor.area,
      currencyFormat.format(double.tryParse(floor.marketRate) ?? 0),
      currencyFormat.format(marketValue),
      currencyFormat.format(double.tryParse(floor.guidelineRate) ?? 0),
      currencyFormat.format(guidelineValue)
    ];
  }).toList();

  final landMarketVal = (double.tryParse(data.landArea) ?? 0) *
      (double.tryParse(data.landUnitRate) ?? 0);
  final landGuideVal = (double.tryParse(data.landArea) ?? 0) *
      (double.tryParse(data.landGuidelineRate) ?? 0);
  final amenitiesMarketVal = (double.tryParse(data.amenitiesArea) ?? 0) *
      (double.tryParse(data.amenitiesUnitRate) ?? 0);
  final amenitiesGuideVal = (double.tryParse(data.amenitiesArea) ?? 0) *
      (double.tryParse(data.amenitiesGuidelineRate) ?? 0);

  double totalMarketValue = landMarketVal + amenitiesMarketVal;
  double totalGuidelineValue = landGuideVal + amenitiesGuideVal;
  double totalArea = (double.tryParse(data.landArea) ?? 0) +
      (double.tryParse(data.amenitiesArea) ?? 0);
  double totalMarketRate = (double.tryParse(data.landUnitRate) ?? 0) +
      (double.tryParse(data.amenitiesUnitRate) ?? 0);
  double totalGuidelineRate = (double.tryParse(data.landGuidelineRate) ?? 0) +
      (double.tryParse(data.amenitiesGuidelineRate) ?? 0);

  for (var floor in data.floors) {
    totalArea += double.tryParse(floor.area) ?? 0;
    totalMarketRate += double.tryParse(floor.marketRate) ?? 0;
    totalGuidelineRate += double.tryParse(floor.guidelineRate) ?? 0;
    totalMarketValue += (double.tryParse(floor.area) ?? 0) *
        (double.tryParse(floor.marketRate) ?? 0);
    totalGuidelineValue += (double.tryParse(floor.area) ?? 0) *
        (double.tryParse(floor.guidelineRate) ?? 0);
  }

  return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
    pw.Text('a. Value of the property (if it is a house) :',
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
    pw.TableHelper.fromTextArray(
      border: pw.TableBorder.all(width: 0.5),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
      cellStyle: const pw.TextStyle(fontSize: 9),
      headers: [
        'Description',
        'Area',
        'Unit Rate',
        'Estimated market value',
        'Unit Rate',
        'Guide line Value'
      ],
      data: [
        [
          'Land',
          data.landArea,
          currencyFormat.format(double.tryParse(data.landUnitRate) ?? 0),
          currencyFormat.format(landMarketVal),
          currencyFormat.format(double.tryParse(data.landGuidelineRate) ?? 0),
          currencyFormat.format(landGuideVal)
        ],
        ['Building', '', '', '', '', ''],
        ...floorRows,
        [
          'Amenities if any',
          data.amenitiesArea,
          currencyFormat.format(double.tryParse(data.amenitiesUnitRate) ?? 0),
          currencyFormat.format(amenitiesMarketVal),
          currencyFormat
              .format(double.tryParse(data.amenitiesGuidelineRate) ?? 0),
          currencyFormat.format(amenitiesGuideVal)
        ],
        [
          'Total Value',
          totalArea.toStringAsFixed(2),
          currencyFormat.format(totalMarketRate),
          currencyFormat.format(totalMarketValue),
          currencyFormat.format(totalGuidelineRate),
          currencyFormat.format(totalGuidelineValue)
        ],
      ],
      cellAlignments: {
        1: pw.Alignment.centerRight,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight
      },
    ),
    pw.SizedBox(height: 5),
    _buildKeyValue('State the source for arriving at the Market Value',
        data.marketValueSourceHouse,
        boldValue: true),
  ]);
}

pw.Widget _buildFlatValuationPdf(
    ValuationData data, NumberFormat currencyFormat) {
  return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
    pw.Text('b. Value of the property (if it is a flat) :',
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
    _buildKeyValue('1. Undivided Share of Land(if applicable)',
        '= ${data.flatUndividedShare}'),
    _buildKeyValue('2. Built Up Area of the Flat', '= ${data.flatBuiltUpArea}'),
    _buildKeyValue('3. Adopted unit composite Rate',
        '= ${currencyFormat.format(double.tryParse(data.flatCompositeRate) ?? 0)}'),
    pw.SizedBox(height: 5),
    pw.TableHelper.fromTextArray(
      border: pw.TableBorder.all(width: 0.5),
      cellStyle: const pw.TextStyle(fontSize: 9),
      cellAlignment: pw.Alignment.center,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
      headers: [
        '4. Estimated Value of the Flat',
        'Unit Rate',
        'Market Value',
        'Guideline Rate',
        'Guideline Value'
      ],
      data: [
        [
          '',
          data.flatValueUnitRate,
          data.flatValueMarket,
          data.flatValueGuidelineRate,
          data.flatValueGuideline,
        ]
      ],
    ),
    pw.SizedBox(height: 5),
    _buildKeyValue('e. State the source for arriving at the Market Value',
        data.marketValueSourceFlat,
        boldValue: false),
    _buildKeyValue('f. Add for extra amenities if any',
        '= ${currencyFormat.format(double.tryParse(data.flatExtraAmenities) ?? 0)}'),
  ]);
}

pw.Widget _buildImprovementDetails(
        ValuationData data, NumberFormat currencyFormat) =>
    pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildKeyValue('1. Description of improvement works...',
            data.improvementDescription),
        _buildKeyValue(
            '2. Amount estimated by the applicant...',
            currencyFormat
                .format(double.tryParse(data.improvementAmount) ?? 0)),
        _buildKeyBoolValue('3. Whether the estimate submitted...is reasonable?',
            data.improvementEstimateReasonable),
      ],
    );

pw.Widget _buildProgressOfWorkTable(ValuationData data) =>
    pw.TableHelper.fromTextArray(
      border: pw.TableBorder.all(width: 0.5),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
      cellStyle: const pw.TextStyle(fontSize: 9),
      headers: [
        'Sr. No.',
        'Description of work',
        'Applicants estimate',
        'Valuers opinion'
      ],
      data: [
        ['1', data.improvementDescription, data.improvementCompletedValue, '']
      ],
    );

pw.Widget _buildRemarks(ValuationData data) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildKeyValue('a) Background information...', data.remarksBackground),
        _buildKeyValue('b) Sources of information...', data.remarksSources),
        _buildKeyValue('c) Procedures adopted...', data.remarksProcedures),
        _buildKeyValue('d) Valuation methodology', data.remarksMethodology),
        _buildKeyValue('e) Major factors that influenced the valuation',
            data.remarksFactors),
      ],
    );

pw.Widget _buildSectionHeader(String title) => pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Text(title,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
    );

pw.Widget _buildKeyValue(String key, String value,
        {bool boldValue = true, bool isSubItem = false}) =>
    pw.Padding(
      padding:
          pw.EdgeInsets.symmetric(vertical: 1, horizontal: isSubItem ? 15 : 0),
      child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Expanded(
            flex: 2,
            child: pw.Text(key, style: const pw.TextStyle(fontSize: 9))),
        pw.Text(': ', style: const pw.TextStyle(fontSize: 9)),
        pw.Expanded(
            flex: 3,
            child: pw.Text(value,
                style: pw.TextStyle(
                    fontWeight:
                        boldValue ? pw.FontWeight.bold : pw.FontWeight.normal,
                    fontSize: 9))),
      ]),
    );

pw.Widget _buildKeyBoolValue(String key, bool value) =>
    _buildKeyValue(key, value ? 'Yes' : 'No');
