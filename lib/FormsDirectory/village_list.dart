class VillageList {
  int? villageId;
  String? villageName;

  VillageList({this.villageId, this.villageName});

  VillageList.fromJson(Map<String, dynamic> json) {
    villageId = json['village_id'];
    villageName = json['village_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['village_id'] = this.villageId;
    data['village_name'] = this.villageName;
    return data;
  }
}