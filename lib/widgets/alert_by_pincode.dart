import 'package:covid_alerter/enums/search_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../slot_provider.dart';

class AlertByPincode extends StatefulWidget
{
  @override
  _AlertByPincodeState createState() => _AlertByPincodeState();
}

class _AlertByPincodeState extends State<AlertByPincode> {
  SlotProvider slotProvider;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    slotProvider= Provider.of(context);
      return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (slotProvider.selectedState != null) districtWidget(),
        Text("Enter PinCode"),
        Padding(
          padding: const EdgeInsets.symmetric(vertical : 8.0),
          child: TextField(
            enabled: !slotProvider.started  ,
            onChanged: (_){
              slotProvider.pinCode = _.trim();

            },
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(

              hintText: "Enter Pincode",
                border: OutlineInputBorder(
              )
            )
          ),
        ),
        if (slotProvider.pinCode != "")
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              color: Colors.blue,
              onPressed: () {
                slotProvider.searchType = SearchType.pinCode;

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
}