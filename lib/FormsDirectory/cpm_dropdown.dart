// To parse this JSON data, do
//
//     final cpmDropdown = cpmDropdownFromJson(jsonString);

import 'dart:convert';

CpmDropdown cpmDropdownFromJson(String str) => CpmDropdown.fromJson(json.decode(str));

String cpmDropdownToJson(CpmDropdown data) => json.encode(data.toJson());

class CpmDropdown {
  List<Village> villages;
  List<Farmer> farmers;

  CpmDropdown({
    required this.villages,
    required this.farmers,
  });

  factory CpmDropdown.fromJson(Map<String, dynamic> json) => CpmDropdown(
    villages: List<Village>.from(json["villages"].map((x) => Village.fromJson(x))),
    farmers: List<Farmer>.from(json["farmers"].map((x) => Farmer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "villages": List<dynamic>.from(villages.map((x) => x.toJson())),
    "farmers": List<dynamic>.from(farmers.map((x) => x.toJson())),
  };
}

class Farmer {
  int farmerId;
  String villageName;
  String fullName;

  Farmer({
    required this.farmerId,
    required this.villageName,
    required this.fullName,
  });

  factory Farmer.fromJson(Map<String, dynamic> json) => Farmer(
    farmerId: json["farmer_id"],
    villageName: json["village_name"],
    fullName: json["full_name"],
  );

  Map<String, dynamic> toJson() => {
    "farmer_id": farmerId,
    "village_name": villageName,
    "full_name": fullName,
  };
}

class Village {
  int villageId;
  String villageName;

  Village({
    required this.villageId,
    required this.villageName,
  });

  factory Village.fromJson(Map<String, dynamic> json) => Village(
    villageId: json["village_id"],
    villageName: json["village_name"],
  );

  Map<String, dynamic> toJson() => {
    "village_id": villageId,
    "village_name": villageName,
  };
}
