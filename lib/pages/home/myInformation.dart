import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share/share.dart';

import '../../scoped-models/main.dart';

class _MyInformationPageState extends State<MyInformationPage> {
  List<Widget> _profileCard(FirebaseUser user) {
    return [
      CircleAvatar(
        backgroundImage: user != null && user.photoUrl != null ? NetworkImage(user.photoUrl) : AssetImage('assets/images/avatar.png'),
        radius: 30.0,
      ),
      SizedBox(
        width: 15.0,
      ),
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: user == null
              ? <Widget>[
                  Text('Login', style: TextStyle(fontSize: 20.0)),
                  SizedBox(
                    height: 5,
                  ),
                  Text('Login to enjoy our services')
                ]
              : <Widget>[
                  Text(
                    '${user.displayName == null ? '' : user.displayName}',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(user.email)
                ])
    ];
  }

  Widget _buildSwitchRoleButton() {
    return Container(
      child: ListTile(
        title: Text(
          'Switch to Tutor',
          style: TextStyle(color: Colors.red),
        ),
        onTap: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: ListView(
        children: <Widget>[
          // User Information
          ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return InkWell(
                child: Padding(padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20), child: Row(children: _profileCard(model.authenticatedUser))),
                onTap: () => Navigator.pushNamed(context, model.authenticatedUser == null ? '/auth' : '/user/info'),
              );
            },
          ),
          Divider(height: 1),
          _buildSwitchRoleButton(),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.mail, color: Colors.blue),
            title: Text('Notification'),
            trailing: Container(
              width: 40.0,
              height: 20,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.red),
              child: Center(
                child: Text(
                  '11',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          ListTile(
              leading: Icon(Icons.person, color: Colors.orangeAccent), title: Text('My Children'), onTap: () => Navigator.pushNamed(context, '/child/view')),
          ListTile(
            leading: Icon(Icons.history, color: Colors.redAccent),
            title: Text('Payment History'),
            onTap: () => {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Share to friend'),
            onTap: () => Share.share("TUTU - the best tutor matching app in Hong Kong - http://tutuapp.hk - join us now!"),
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
    return _MyInformationPageState();
  }
}
