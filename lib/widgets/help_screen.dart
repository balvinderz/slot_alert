import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("1. Find Slot by District and State"),
        Padding(
          padding: EdgeInsets.only(top: 4, left: 50),
          child: Text(
              "i) Select State from the dropdown\nii) Select District From the dropdown.\niii) Click on Start "),
        ),
        Text("2. Find Slot by Pincode"),
        Padding(
          padding: EdgeInsets.only(top: 4, left: 50),
          child: Text(
              "i)Enter  Pincode in the textfield\nii) Click on Start.If not centers are available in  that pincode , the program will alert you and stop. "),
        ),
        SizedBox(height: 10,),
        Text("You will hear this sound when a slot is found"),
        Padding(
          padding: const EdgeInsets.only(top : 10.0),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            onPressed: () async {
              Media media2 = await Media.asset('assets/test.mp3');
              Player player = new Player(
                id: 69420,
                videoWidth: 0,
                videoHeight: 0,
              );
              player.add(media2);
              await player.play();

            },
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Play Sound"),
            ),
          ),
        )
      ],
    );
  }
}
