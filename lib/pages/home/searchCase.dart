import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import "package:google_maps_flutter/google_maps_flutter.dart";
import 'package:simple_permissions/simple_permissions.dart';
import '../../libraries/blackdrop.dart';

class SearchCasePageState extends State<SearchCasePage> {
  int currentpage = 0;
  GoogleMapController _mapController;
  Location _location = Location();
  bool _permission = false;
  double _lat, _long;
  String error;

  List<Map<String, dynamic>> cases = [
    {
      'garde_level': '中二',
      'subjects': ['中文', '英文'],
      'request_detail': '接近純正英國囗音，遊戲方式進行..',
      'location': {'lat': 22.285237, 'long': 114.224488, 'name': '嘉享灣'},
      'gender': '男',
      'days': {'一': "1000-1100", '三': "1500-1630"},
      'age': 21,
      'price': 500
    },
    {
      'garde_level': '小二',
      'subjects': ['中文', '英文'],
      'request_detail': '接近純正英國囗音，遊戲方式進行..',
      'location': {'lat': 22.403257, 'long': 113.979785, 'name': '景峰花園'},
      'gender': '女',
      'days': {'二': "1000-1100", '三': "再議"},
      'age': 13,
      'price': 300
    }
  ];

  initState() {
    super.initState();
    _getLocation();
  }

  void _getLocation() async {
    Map<String, double> location;

    try {
      _permission = await _location.hasPermission();
      if (_permission) {
        location = await _location.getLocation();
      }

      error = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'Permission denied - please ask the user to enable it from the app settings';
      }

      location = {'latitude': 22.327352, 'longitude': 114.173051};
    }

    setState(() {
      _lat = location['latitude'];
      _long = location['longitude'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _permission == false
            ? InkWell(
                onTap: () => SimplePermissions.requestPermission(Permission.AccessFineLocation).then((PermissionStatus result) {
                      if (result == PermissionStatus.authorized) {
                        setState(() {
                          _getLocation();
                        });
                      }
                    }),
                child: Container(
                  height: 45.0,
                  width: double.infinity,
                  color: Colors.red[500],
                  child: Center(
                    child: Text(
                      'Enable location permission',
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                  ),
                ),
              )
            : Container(),
        Expanded(
            child: Backdrop(
          frontHeader: PageView(
              scrollDirection: Axis.horizontal,
              controller: PageController(
                initialPage: currentpage,
                keepPage: false,
              ),
              onPageChanged: (value) {
                setState(() {
                  currentpage = value;
                  _mapController.animateCamera(CameraUpdate.newLatLng(LatLng(cases[value]['location']['lat'], cases[value]['location']['long'])));
                });
              },
              children: cases.map((tcase) {
                return Container(
                  decoration: BoxDecoration(border: Border(top: BorderSide(width: 2, color: Colors.orange))),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                '${tcase["garde_level"]} / 中文 英文',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.person),
                              Text("男 21")
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("接近純正英國囗音，遊戲方式進行..")
                        ],
                      ),
                      Spacer(),
                      Center(
                        child: Text("\$500", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                );
              }).toList()),
          panelVisible: ValueNotifier<bool>(false),
          frontPanelOpenHeight: 40.0,
          frontHeaderHeight: 100.0,
          frontHeaderVisibleClosed: true,
          frontLayer: caseDetails(cases[currentpage]),
          backLayer: Stack(
            alignment: FractionalOffset(0.5, 0.98),
            children: <Widget>[
              GoogleMap(
                onMapCreated: (controller) {
                  _mapController = controller;

                  cases.forEach((tcase) {
                    _mapController.addMarker(MarkerOptions(
                        infoWindowText: InfoWindowText('\$ ${tcase['price'].toString()}', null),
                        position: LatLng(tcase['location']['lat'], tcase['location']['long'])));
                  });
                },
                options: GoogleMapOptions(
                  myLocationEnabled: true,
                  cameraPosition: CameraPosition(target: LatLng(_lat = 22.338838, _long = 114.182190), zoom: 15.0),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}

Widget caseDetails(Map<String, dynamic> tcase) {
  TextStyle _titleTextStyle = TextStyle(fontSize: 17.0);
  GoogleMapController _mapController;
  return ListView(
    padding: EdgeInsets.symmetric(horizontal: 15),
    children: <Widget>[
      Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('上課時間', style: _titleTextStyle),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: tcase['days'].keys.map<Widget>((String day) {
                return Text('星期${day}  ${tcase['days'][day]}');
              }).toList(),
            ),
          ],
        ),
      ),
      Divider(),
      Text('授課位置', style: _titleTextStyle),
      SizedBox(
        height: 10,
      ),
      Container(
        height: 200.0,
        child: GoogleMap(
          onMapCreated: (controller) {
            _mapController = controller;
            _mapController.addMarker(MarkerOptions(
                infoWindowText: InfoWindowText('\$ ${tcase['price'].toString()}', null),
                position: LatLng(tcase['location']['lat'], tcase['location']['long'])));
          },
          options: GoogleMapOptions(
              scrollGesturesEnabled: false,
              cameraPosition: CameraPosition(target: LatLng(tcase['location']['lat'], tcase['location']['long']), zoom: 15.0)),
        ),
      )
    ],
  );
}

class SearchCasePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchCasePageState();
  }
}
