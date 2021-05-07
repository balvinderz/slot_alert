class District {
  int districtId;
  String districtName;
  District({this.districtId, this.districtName});

  factory District.fromJson(Map json) {
    return District(districtId: json['district_id'], districtName: json['district_name']);
  }
}
