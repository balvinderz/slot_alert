class Session {
  String sessionId;
  int availableCapacity;
  int minAgeLimit;
  Session({this.sessionId,this.availableCapacity,this.minAgeLimit});
  factory Session.fromJson(Map json){
    return Session(
      sessionId: json['session_id'],
      availableCapacity: json['available_capacity'],
      minAgeLimit: json['min_age_limit'],
    );
  }
}