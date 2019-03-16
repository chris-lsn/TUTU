import 'package:flutter/material.dart';
import "package:google_maps_flutter/google_maps_flutter.dart";

class ViewCaseState extends State<ViewCasePage> {
  TextStyle _valStyle = TextStyle(fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('')),
        body: ListView(
          children: <Widget>[
            Container(
              height: 300.0,
              child: GoogleMap(
                onMapCreated: (controller) {},
                options: GoogleMapOptions(myLocationEnabled: true, cameraPosition: CameraPosition(target: LatLng(22.285237, 114.224488), zoom: 15.0)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                    Text('Student name'),
                    Text('陳小友', style: _valStyle),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Educational Stage'),
                    Text('中學', style: _valStyle),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Gender'),
                    Text('男', style: _valStyle),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Tutoring Subject'),
                    Text('中文，英文，數學', style: _valStyle),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Price'),
                    Text('\$500 per lesson', style: _valStyle),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: RaisedButton(
                        child: Text("Contact", style: TextStyle(color: Colors.white, fontSize: 16)),
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        onPressed: () async {},
                      ),
                    )
                  ]),
                ),
              ),
            )
          ],
        ));
  }
}

class ViewCasePage extends StatefulWidget {
  final Map<String, dynamic> cases = null;

  @override
  State<StatefulWidget> createState() {
    return ViewCaseState();
  }
}
