import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../scoped-models/main.dart';
// import '../../controller/user.dart';

class _MyInformationPageState extends State<MyInformationPage> {
  Map _initUserData;

  List<Widget> _profileCard(FirebaseUser user) {
    return [
      CircleAvatar(
        backgroundImage: user != null && user.photoUrl != null
            ? NetworkImage(user.photoUrl)
            : AssetImage('assets/images/avatar.png'),
        radius: 30.0,
      ),
      SizedBox(
        width: 15.0,
      ),
      user == null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                  Text('Login', style: TextStyle(fontSize: 20.0)),
                  SizedBox(
                    height: 5,
                  ),
                  Text('Login to enjoy our services')
                ])
          : Text(
              '${user.displayName == null ? '' : user.displayName}',
              style: TextStyle(fontSize: 20.0),
            )
    ];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
      child: ListView(
        children: <Widget>[
          // User Information
          ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model) {
            return InkWell(
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 20),
                          child: Row(
                              children: _profileCard(model.authenticatedUser))),
                      onTap: () => Navigator.pushNamed(context,
                          model.authenticatedUser == null ? '/auth' : '/user/info'),
                    );
          },), 
          Divider(),
          ListTile(
            leading: Icon(Icons.mail, color: Colors.blue),
            title: Text('Notification'),
            trailing: Container(
              width: 40.0,
              height: 20,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.red),
              child: Center(
                child: Text(
                  '11',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          ListTile(
              leading: Icon(Icons.person, color: Colors.orangeAccent),
              title: Text('My Children'),
              onTap: () => Navigator.pushNamed(context, '/child/view')),
          ListTile(
            leading: Icon(Icons.history, color: Colors.redAccent),
            title: Text('Payment History'),
            onTap: () => {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Share to friend'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Setting'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('Contact us'),
            onTap: () => {},
          ),
          Divider(),
          ListTile(
            title: Text('About us'),
            onTap: () => {},
          ),
        ],
      ),
    ));
  }
}

class MyInformationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyInformationPageState();
  }
}
