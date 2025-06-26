import 'dart:typed_data';

class ValuationImage {
  final Uint8List imageFile;
  String latitude;
  String longitude;
  ValuationImage({
    required this.imageFile,
    this.latitude = '',
    this.longitude = '',
  });
}

class ValuationData {
  
  String nearbyLatitude;
  String nearbyLongitude;

  // Valuer Header Info
  String valuerNameAndQuals;
  String valuerCredentials;
  String valuerAddressLine1;
  String valuerMob;
  String valuerEmail;

  // Header
  String bankName;
  String branchName;

  // General Section
  String caseType;
  DateTime? inspectionDate;
  String applicationNo;
  String titleHolderName;
  String borrowerName;

  // Documents Verified
  String landTaxReceiptNo;
  String possessionCertNo;
  String locationSketchNo;
  String thandaperAbstractNo;
  String approvedLayoutPlanNo;
  String approvedBuildingPlanNo;

  // Physical Details of Land
  String briefDescription;
  String locationAndLandmark;
  String reSyNo;
  String blockNo;
  String village;
  String taluk;
  String district;
  String state;
  String postOffice;
  String pinCode;
  String postalAddress;

  // Boundaries
  String northAsPerSketch;
  String northActual;
  String southAsPerSketch;
  String southActual;
  String eastAsPerSketch;
  String eastActual;
  String westAsPerSketch;
  String westActual;

  // Page 2 Details
  String localAuthority;
  bool isPropertyIdentified;
  String plotDemarcated;
  String natureOfProperty;
  String classOfProperty;
  String topographicalCondition;
  bool chanceOfAcquisition;
  String approvedLandUse;
  String fourWheelerAccessibility;
  String occupiedBy;
  String yearsOfOccupancy;
  String ownerRelationship;

  // Area Details
  String areaOfLand;
  String saleableArea;

  // Detailed Valuation (Land)
  String landExtent;
  String landRatePerCent;
  String landTotalValue;
  String landMarketValue;
  String landRealizableValue;
  String landDistressValue;
  String landFairValue;

  String buildingPlinth;
  String buildingRatePerSqft;
  String buildingTotalValue;
  String buildingMarketValue;
  String buildingRealizableValue;
  String buildingDistressValue;

  // II. PHYSICAL DETAILS OF BUILDING
  String buildingNo;
  String approvingAuthority;
  String stageOfConstruction;
  String typeOfStructure;
  String noOfFloors;
  String livingDiningRooms;
  String bedrooms;
  String toilets;
  String kitchen;
  String typeOfFlooring;
  String ageOfBuilding;
  String residualLife;
  String violationObserved;

  // Grand Total
  String grandTotalMarketValue;
  String grandTotalRealizableValue;
  String grandTotalDistressValue;

  // Declaration
  DateTime? declarationDate;
  String declarationPlace;
  String valuerName;
  String valuerAddress;

  late List<ValuationImage> images;

  ValuationData({
    this.nearbyLatitude='',
    this.nearbyLongitude='',
    this.valuerNameAndQuals = 'Er. Belram S.U. B.Tech, AMIE, AIV',
    this.valuerCredentials =
        'Chartered Engineer (AM 190746-0)\nApproved Valuer Cat 1 (A-29296)\nPanel Valuer of IDBI Bank',
    this.valuerAddressLine1 =
        'Ushas Nivas TC 7/1997-1 Pangode Thirumala PO Thiruvananthapuram Pin Code - 695006',
    this.valuerMob = '+91-8089697914',
    this.valuerEmail = 'belramsu@gmail.com',

    this.buildingPlinth = '--',
    this.buildingRatePerSqft = '--',
    this.buildingTotalValue = '--',
    this.buildingMarketValue = '--',
    this.buildingDistressValue = '--',
    this.buildingRealizableValue = '--',

    this.bankName = 'IDBI BANK',
    this.branchName = 'ULLOOR BRANCH',
    this.caseType = 'Agricultural loan',
    this.inspectionDate,
    this.applicationNo = '',
    this.titleHolderName = 'Sri. PARAMESWARAN.K',
    this.borrowerName = 'Sri. ABHILASH PARAMESWARAN',
    this.landTaxReceiptNo = '0539776 dt 26-02-2015',
    this.possessionCertNo = '1197/2015',
    this.locationSketchNo = '1197/2015',
    this.thandaperAbstractNo = '1197/2015',
    this.approvedLayoutPlanNo = 'NA',
    this.approvedBuildingPlanNo = 'NA',
    this.briefDescription =
        'The property only land with an extent of 37.20Ares (91.90Cents) as per site inspection.',
    this.locationAndLandmark =
        'The property is located on the east side of channel bund road leads from RK Auditorium on Kuttichal - Kattakada main road and is on the rear side of Thozhuthinkara Durga devi temple.',
    this.reSyNo = '253/9',
    this.blockNo = '45',
    this.village = 'Mannoorkara',
    this.taluk = 'Kattakada',
    this.district = 'Trivandrum',
    this.state = 'Kerala',
    this.postOffice = 'Kuttichal',
    this.pinCode = '695574',
    this.postalAddress =
        'Re Sy. 253/9\nKuttichal\nThozhuthinkara\nKuttichal PO\nTrivandrum - 695574',
    this.northAsPerSketch = 'Sreekantan',
    this.northActual = 'Sreekantan',
    this.southAsPerSketch = 'Sudharma',
    this.southActual = 'Sudharma',
    this.eastAsPerSketch =
        'Rajan, Jijima, Omana Pilla, Appukuttan Nair & Madhusoodhanan Nair',
    this.eastActual =
        'Rajan, Jijima, Omana Pilla, Appukuttan Nair & Madhusoodhanan Nair',
    this.westAsPerSketch = 'Channel bund road',
    this.westActual = 'Channel bund road',
    this.localAuthority = 'Kuttichal grama panchayath',
    this.isPropertyIdentified = true,
    this.plotDemarcated = 'Barbed wire fencing',
    this.natureOfProperty = 'Agricultural land',
    this.classOfProperty = 'Middle & Semi Urban',
    this.topographicalCondition = 'Flat',
    this.chanceOfAcquisition = false,
    this.approvedLandUse = 'Wet land (As per inspection)',
    this.fourWheelerAccessibility = '02.00mts wide mud road',
    this.occupiedBy = 'Owner',
    this.yearsOfOccupancy = '30years',
    this.ownerRelationship = 'NA',
    this.areaOfLand = '37.20Ares (91.90Cents)',
    this.saleableArea = '37.20Ares (91.90Cents)',
    this.landExtent = '91.90Cents',
    this.landRatePerCent = '50,000/Cent',
    this.landTotalValue = '45,95,000/-',
    this.landMarketValue = '45,95,000/-',
    this.landRealizableValue = '41,00,000/- (Land)',
    this.landDistressValue = '36,00,000/-',
    this.landFairValue = '26,400/Are',
    this.grandTotalMarketValue = '45,95,000/-',
    this.grandTotalRealizableValue = '41,00,000/-',
    this.grandTotalDistressValue = '36,00,000/-',
    this.declarationDate,
    this.declarationPlace = 'Trivandrum',
    this.valuerName = 'Er. BELRAM S.U, B.Tech, AMIE, AIV',
    this.valuerAddress =
        'Ushas Nivas TC 7/1997-1, Pangode\nThirumala PO, Trivandrum - 695006',

    // Add these new properties to the constructor in ValuationData
    this.buildingNo = '--',
    this.approvingAuthority = '--',
    this.stageOfConstruction = '--',
    this.typeOfStructure = '--',
    this.noOfFloors = '--',
    this.livingDiningRooms = '--',
    this.bedrooms = '--',
    this.toilets = '--',
    this.kitchen = '--',
    this.typeOfFlooring = '--',
    this.ageOfBuilding = '--',
    this.residualLife = '--',
    this.violationObserved = '--',
  });
}
