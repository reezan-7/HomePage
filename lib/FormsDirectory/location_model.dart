// To parse this JSON data, do
//
//     final locationModel = locationModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LocationModel locationModelFromJson(String str) => LocationModel.fromJson(json.decode(str));

String locationModelToJson(LocationModel data) => json.encode(data.toJson());

class LocationModel {
  List<States> states;
  List<Province> provinces;

  LocationModel({
    required this.states,
    required this.provinces,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    states: List<States>.from(json["states"].map((x) => States.fromJson(x))),
    provinces: List<Province>.from(json["provinces"].map((x) => Province.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "states": List<dynamic>.from(states.map((x) => x.toJson())),
    "provinces": List<dynamic>.from(provinces.map((x) => x.toJson())),
  };
}

class Province {
  int id;
  int stateId;
  String name;

  Province({
    required this.id,
    required this.stateId,
    required this.name,
  });

  factory Province.fromJson(Map<String, dynamic> json) => Province(
    id: json["id"],
    stateId: json["state_id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "state_id": stateId,
    "name": name,
  };
}

class States {
  int id;
  String name;

  States({
    required this.id,
    required this.name,
  });

  factory States.fromJson(Map<String, dynamic> json) => States(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
