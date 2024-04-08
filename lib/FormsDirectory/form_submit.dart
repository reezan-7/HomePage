// To parse this JSON data, do
//
//     final formSubmit = formSubmitFromJson(jsonString);

import 'dart:convert';

FormSubmit formSubmitFromJson(String str) => FormSubmit.fromJson(json.decode(str));

String formSubmitToJson(FormSubmit data) => json.encode(data.toJson());

class FormSubmit {
  String fullName;
  int contactNumber;
  String identityProof;
  String identityProofNumber;
  String landDetails;
  int totalAreaOfFarmland;
  String majorCropsGrown;
  int noOfCropCyclePerYear;
  String typeOfFertilizersUsed;
  int quantityOfFertilizersUsed;
  int noOfYearsOnFarming;
  DateTime date;
  int villageName;

  FormSubmit({
    required this.fullName,
    required this.contactNumber,
    required this.identityProof,
    required this.identityProofNumber,
    required this.landDetails,
    required this.totalAreaOfFarmland,
    required this.majorCropsGrown,
    required this.noOfCropCyclePerYear,
    required this.typeOfFertilizersUsed,
    required this.quantityOfFertilizersUsed,
    required this.noOfYearsOnFarming,
    required this.date,
    required this.villageName,
  });

  factory FormSubmit.fromJson(Map<String, dynamic> json) => FormSubmit(
    fullName: json["full_name"],
    contactNumber: json["contact_number"],
    identityProof: json["identity_proof"],
    identityProofNumber: json["identity_proof_number"],
    landDetails: json["land_details"],
    totalAreaOfFarmland: json["total_area_of_farmland"],
    majorCropsGrown: json["major_crops_grown"],
    noOfCropCyclePerYear: json["no_of_crop_cycle_per_year"],
    typeOfFertilizersUsed: json["type_of_fertilizers_used"],
    quantityOfFertilizersUsed: json["quantity_of_fertilizers_used"],
    noOfYearsOnFarming: json["no_of_years_on_farming"],
    date: DateTime.parse(json["date"]),
    villageName: json["village_name"],
  );

  Map<String, dynamic> toJson() => {
    "full_name": fullName,
    "contact_number": contactNumber,
    "identity_proof": identityProof,
    "identity_proof_number": identityProofNumber,
    "land_details": landDetails,
    "total_area_of_farmland": totalAreaOfFarmland,
    "major_crops_grown": majorCropsGrown,
    "no_of_crop_cycle_per_year": noOfCropCyclePerYear,
    "type_of_fertilizers_used": typeOfFertilizersUsed,
    "quantity_of_fertilizers_used": quantityOfFertilizersUsed,
    "no_of_years_on_farming": noOfYearsOnFarming,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "village_name": villageName,
  };
}
