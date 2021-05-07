import 'package:covid_alerter/models/session.dart';

class HospitalCenter{
  int centerId;
  String name;
  String address;

  List<Session> sessions;

  HospitalCenter({this.centerId, this.name, this.address, this.sessions});
  factory HospitalCenter.fromJson(Map json){
    return HospitalCenter(
      centerId: json['center_id'],
      address:  json['address'],
      name: json['name'],
      sessions: (json['sessions'] as List).map((e) => Session.fromJson(e)).toList()
    );
  }
}