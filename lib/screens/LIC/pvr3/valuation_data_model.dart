// lib/valuation_data_model.dart

import 'dart:typed_data';

enum DeviationNature { NIL, Minor, Major }

enum OccupantStatus { Occupied, Rented }

enum PropertyType { House, Flat } // To choose between property types

class ValuationImage {
  final Uint8List imageFile;
  String latitude;
  String longitude;
  ValuationImage(
      {required this.imageFile, this.latitude = '', this.longitude = ''});
}

class FloorData {
  String name; // e.g., "GF", "FF"
  String area;
  String marketRate;
  String guidelineRate;
  FloorData(
      {required this.name,
      this.area = '0',
      this.marketRate = '0',
      this.guidelineRate = '0'});
}

// ADDED: New class to represent a row in the "Progress of Work" table
class ProgressWorkItem {
  
  String description;
  String applicantEstimate;
  String valuerOpinion;
  ProgressWorkItem(
      {this.description = '',
      this.applicantEstimate = '',
      this.valuerOpinion = ''});
}

class ValuationData {

  String nearbyLatitude;
  String nearbyLongitude;

  // Header
  final String fileNo,
      valuerName,
      valuerCode,
      appointingAuthority,
      reraNo,
      scheme;
  final DateTime inspectionDate;

  // Property Details
  final String applicantName, documentPerused, propertyAddress;
  final bool locationSketchVerified;
  final String northBoundary, southBoundary, eastBoundary, westBoundary;
  final String northDim, southDim, eastDim, westDim;
  final String extent1, extent2, propertyType;
  final OccupantStatus occupantStatus;
  final String occupantName,
      usageOfBuilding,
      nearbyLandmark,
      surroundingAreaDev;
  final bool basicAmenitiesAvailable;
  final String negativesToLocality, favourableConsiderations, otherFeatures;

  // Drawing
  final bool approvedDrawingAvailable;
  final String approvalNoAndDate, drawingDeviations;
  final bool constructionAsPerPlan;
  final DeviationNature deviationNature;

  // Building Details
  final String marketability, buildingAge, residualLife, fsiApproved, fsiActual;
  final String specFoundation, specRoof, specFlooring, qualityOfConstruction;
  final bool adheresToSafetySpecs, highTensionLineImpact;

  // Valuation Details
  final PropertyType valuationType;

  // For 'House' type valuation
  final String landArea, landUnitRate, landGuidelineRate;
  final List<FloorData> floors;
  final String amenitiesArea, amenitiesUnitRate, amenitiesGuidelineRate;
  final String marketValueSourceHouse;

  // For 'Flat' type valuation
  final String flatUndividedShare, flatBuiltUpArea, flatCompositeRate;
  final String flatValueUnitRate,
      flatValueMarket,
      flatValueGuideline,
      flatValueGuidelineRate;
  final String marketValueSourceFlat, flatExtraAmenities;

  // Improvement & Progress
  final String improvementDescription, improvementAmount;
  final bool improvementEstimateReasonable;
  final String improvementReasonableEstimate; // ADDED: For section 5, point 4
  final List<ProgressWorkItem>
      progressWorkItems; // MODIFIED: For section 6 table

  // Remarks
  final String remarksBackground,
      remarksSources,
      remarksProcedures,
      remarksMethodology,
      remarksFactors;

  // Images
  final List<ValuationImage> images;

  ValuationData({
    this.nearbyLatitude='',
    this.nearbyLongitude='',
    required this.fileNo,
    required this.valuerName,
    required this.valuerCode,
    required this.appointingAuthority,
    required this.inspectionDate,
    required this.reraNo,
    required this.scheme,
    required this.applicantName,
    required this.documentPerused,
    required this.propertyAddress,
    required this.locationSketchVerified,
    required this.northBoundary,
    required this.southBoundary,
    required this.eastBoundary,
    required this.westBoundary,
    required this.northDim,
    required this.southDim,
    required this.eastDim,
    required this.westDim,
    required this.extent1,
    required this.extent2,
    required this.propertyType,
    required this.occupantStatus,
    required this.occupantName,
    required this.usageOfBuilding,
    required this.nearbyLandmark,
    required this.surroundingAreaDev,
    required this.basicAmenitiesAvailable,
    required this.negativesToLocality,
    required this.favourableConsiderations,
    required this.otherFeatures,
    required this.approvedDrawingAvailable,
    required this.approvalNoAndDate,
    required this.constructionAsPerPlan,
    required this.drawingDeviations,
    required this.deviationNature,
    required this.marketability,
    required this.buildingAge,
    required this.residualLife,
    required this.fsiApproved,
    required this.fsiActual,
    required this.specFoundation,
    required this.specRoof,
    required this.specFlooring,
    required this.qualityOfConstruction,
    required this.adheresToSafetySpecs,
    required this.highTensionLineImpact,
    required this.valuationType,
    required this.landArea,
    required this.landUnitRate,
    required this.landGuidelineRate,
    required this.floors,
    required this.amenitiesArea,
    required this.amenitiesUnitRate,
    required this.amenitiesGuidelineRate,
    required this.marketValueSourceHouse,
    required this.flatUndividedShare,
    required this.flatBuiltUpArea,
    required this.flatCompositeRate,
    required this.flatValueUnitRate,
    required this.flatValueMarket,
    required this.flatValueGuideline,
    required this.flatValueGuidelineRate,
    required this.marketValueSourceFlat,
    required this.flatExtraAmenities,
    required this.improvementDescription,
    required this.improvementAmount,
    required this.improvementEstimateReasonable,
    required this.improvementReasonableEstimate, // ADDED
    required this.progressWorkItems, // MODIFIED
    required this.remarksBackground,
    required this.remarksSources,
    required this.remarksProcedures,
    required this.remarksMethodology,
    required this.remarksFactors,
    required this.images,
  });
}
