class CountryState {
  int stateId;
  String stateName;

  CountryState({this.stateId, this.stateName});

  factory CountryState.fromJson(Map json) {
    return CountryState(stateId: json['state_id'], stateName: json['state_name']);
  }
}
