// To parse this JSON data, do
//
//     final cpmDropdown = cpmDropdownFromJson(jsonString);

import 'dart:convert';

List<CpmDropdown> cpmDropdownFromJson(String str) => List<CpmDropdown>.from(json.decode(str).map((x) => CpmDropdown.fromJson(x)));

String cpmDropdownToJson(List<CpmDropdown> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CpmDropdown {
  int farmerId;
  String fullName;
  String villageName;

  CpmDropdown({
    required this.farmerId,
    required this.fullName,
    required this.villageName,
  });

  factory CpmDropdown.fromJson(Map<String, dynamic> json) => CpmDropdown(
    farmerId: json["farmer_id"],
    fullName: json["full_name"],
    villageName: json["village_name"],
  );

  Map<String, dynamic> toJson() => {
    "farmer_id": farmerId,
    "full_name": fullName,
    "village_name": villageName,
  };
}
