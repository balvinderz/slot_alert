import 'dart:ffi';

import 'package:covid_alerter/slot_provider.dart';
import 'package:covid_alerter/widgets/alert_by_district.dart';
import 'package:covid_alerter/widgets/alert_by_pincode.dart';
import 'package:covid_alerter/widgets/help_screen.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main()  {

  runApp(
    ChangeNotifierProvider(
      create: (_) => SlotProvider(),
      child: MaterialApp(
        title: "Slot Alert",
        theme: ThemeData.dark(),
        home: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool startSearching = false;
  bool gotState = false;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Provider.of<SlotProvider>(context, listen: false).getStates();
    Provider.of<SlotProvider>(context, listen: false).startSlotAlerter();
  }

  SlotProvider slotProvider;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    slotProvider = Provider.of(context);
    slotProvider.context = context;
    slotProvider.scaffoldKey = scaffoldKey;

    return Scaffold(
      key: scaffoldKey,

      body: Stack(
        children: [
          Row(
            children: [
              NavigationRail(
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    NavigationRailDestination(
                        icon: Icon(Icons.alarm),
                        label: Text(
                          "Alert By District",
                          style: TextStyle(color: Colors.white),
                        )),
                    NavigationRailDestination(
                        icon: Icon(Icons.alarm), label: Text("Alert By Pincode")),
                    NavigationRailDestination(
                        icon: Icon(Icons.help), label: Text("Help")),
                  ],
                  onDestinationSelected: (_){

                    slotProvider.index = _;

                  },
                  selectedIndex: slotProvider.index),
              Expanded(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: IndexedStack(
                        index: slotProvider.index,
                        children: [
                          AlertByDistrict(),
                          AlertByPincode(),
                          HelpScreen()
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Made with ❤ by Balvinder Singh Gambhir",style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),

        ],
      ),
    );
  }


}
