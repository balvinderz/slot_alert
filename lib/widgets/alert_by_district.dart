import 'package:covid_alerter/slot_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlertByDistrict extends StatefulWidget {
  @override
  _AlertByDistrictState createState() => _AlertByDistrictState();
}

class _AlertByDistrictState extends State<AlertByDistrict> {
  SlotProvider slotProvider;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    slotProvider = Provider.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select State"),
        DropdownButton(
          items: slotProvider.states
              .map((e) => DropdownMenuItem(
                    child: Text(e.stateName),
                    value: e,
                  ))
              .toList(),
          isExpanded: true,
          value: slotProvider.selectedState,
          onChanged: slotProvider.started
              ? null
              : (_) {
                  slotProvider.selectedState = _;
                },
        ),
        if (slotProvider.selectedState != null) districtWidget(),
        if (slotProvider.selectedDistrict != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              color: Colors.blue,
              onPressed: () {
                slotProvider.started = !slotProvider.started;
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(!slotProvider.started ? "Start" : "Stop"),
              ),
            ),
          ),
        if (slotProvider.started)
          Text("Request sent : ${slotProvider.requestSent}"),
        if (slotProvider.centersWithSlots != null)
          Text("Center with Slot Found : ${slotProvider.centersWithSlots.name}")
      ],
    );
  }

  Widget districtWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select District"),
        DropdownButton(
          items: slotProvider.districts
              .map((e) => DropdownMenuItem(
                    child: Text(e.districtName),
                    value: e,
                  ))
              .toList(),
          isExpanded: true,
          value: slotProvider.selectedDistrict,
          onChanged: slotProvider.started
              ? null
              : (_) {
                  slotProvider.selectedDistrict = _;
                },
        ),
      ],
    );
  }
}
