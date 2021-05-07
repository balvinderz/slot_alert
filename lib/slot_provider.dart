import 'dart:convert';
import 'dart:math';

import 'package:covid_alerter/enums/search_type.dart';
import 'package:covid_alerter/models/district.dart';
import 'package:covid_alerter/models/hospital_center.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'models/state.dart';

class SlotProvider extends ChangeNotifier {
  List<CountryState> states = [];
  List<District> districts = [];
  CountryState _selectedState;
  District _selectedDistrict;
  bool _started = false;
  int _requestSent = 0;
  HospitalCenter centersWithSlots;
  SearchType searchType = SearchType.district;
  int _index = 0;
  bool boxShown = false;
  String _pinCode = "";
  int waitTime = 1;

  BuildContext context;

  GlobalKey<ScaffoldState> scaffoldKey;


  String get pinCode => _pinCode;

  set pinCode(String value) {
    _pinCode = value;
    notifyListeners();
  }

  int get index => _index;

  set index(int value) {
    _index = value;
    notifyListeners();
  }

  int get requestSent => _requestSent;

  String get todaysDate {
    DateTime time = DateTime.now();
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    List<String> splittedFormat = formatted.split("-");
    return "${splittedFormat[2]}-${splittedFormat[1]}-${splittedFormat[0]}";
  }

  set requestSent(int value) {
    _requestSent = value;
    notifyListeners();
  }

  bool hospitalFound = false;

  String hospitalName = "";

  District get selectedDistrict => _selectedDistrict;

  bool get started => _started;

  set started(bool value) {
    _started = value;
    boxShown = false ;

    if (_started) {
      requestSent = 0;
      centersWithSlots = null;

    }
    notifyListeners();
  }

  set selectedDistrict(District value) {
    _selectedDistrict = value;
    notifyListeners();
  }

  CountryState get selectedState => _selectedState;

  set selectedState(CountryState value) {
    _selectedState = value;
    notifyListeners();
    getDistricts();
  }

  Future<void> getDistricts() async {
    try {
      String baseUrl =
          "https://cdn-api.co-vin.in/api/v2/admin/location/districts/${selectedState
          .stateId}";
      districts.clear();

      final districtResponse = await get(Uri.parse(baseUrl), headers: {
        "user-agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36"
      });
      districts = ((jsonDecode(districtResponse.body)['districts']) as List)
          .map((e) => District.fromJson(e))
          .toList();
      selectedDistrict = districts.first;
    } catch (e) {
      await Future.delayed(Duration(seconds: 1));
      getDistricts();
    }
  }

  Future<void> getStates() async {
    try {
      String baseUrl = "https://cdn-api.co-vin.in/api/v2/admin/location/states";

      final stateResponse = await get(Uri.parse(baseUrl), headers: {
        "user-agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36"
      });
      states = ((jsonDecode(stateResponse.body)['states']) as List)
          .map((e) => CountryState.fromJson(e))
          .toList();
      if (selectedState != null) selectedState = states.first;

      notifyListeners();
    } catch (e) {
      await Future.delayed(Duration(seconds: 1));
      getStates();
    }
  }

  Future<void> startSlotAlerter() async {
    Media media2 = await Media.asset('assets/test.mp3');
    Player player = new Player(
      id: 69420,
      videoWidth: 0,
      videoHeight: 0,
    );
    await player.add(media2);
    while (true) {
      if (started)
       {
        String baseUrl;

        if (searchType == SearchType.district) {
          baseUrl =
          "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=${selectedDistrict
              .districtId}&date=$todaysDate}";
        }
        else
          baseUrl =
          "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=$pinCode&date=$todaysDate";

        try {
          final response = await get(Uri.parse(baseUrl), headers: {
            "user-agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36"
          });
          print(baseUrl);
          List<HospitalCenter> centers =
          ((jsonDecode(response.body)['centers'] as List)
              .map((e) => HospitalCenter.fromJson(e))).toList();
          waitTime = 1;

          if(centers.length==0 && searchType == SearchType.pinCode) {
          scaffoldKey.currentState.showSnackBar(SnackBar(content: Text( "No Centers found for this Pincode :*(",style: TextStyle(
            color: Colors.white
          ),),backgroundColor: Colors.red,));
          started = false ;

          }
          centers.forEach((element) {
            element.sessions.forEach((session) async {
              if (session.minAgeLimit == 18 && session.availableCapacity != 0) {
                centersWithSlots = element;
                await player.play();
                if(!boxShown){
                  boxShown = true ;


                }

              }

            });
          });

          requestSent += 1;
        } catch (e) {
          print(e);

          waitTime = min(30,waitTime*2);
          scaffoldKey.currentState.showSnackBar(SnackBar(content: Text( "Some Error Occured :( .  Waiting for $waitTime seconds",style: TextStyle(
              color: Colors.white
          ),),backgroundColor: Colors.red,));
          await Future.delayed(Duration(seconds: waitTime));
        }
      }
      await Future.delayed(Duration(seconds: 1));

    }
  }
}
