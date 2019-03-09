import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share/share.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../models/modes/userRole.dart';
import '../../scoped-models/main.dart';

class _MyInformationPageState extends State<MyInformationPage> {
  Color _userRoleColor = Colors.white;

  Color _getUserRoleColor(UserRole userRole) {
    switch (userRole) {
      case UserRole.Parent:
        return Colors.orange;
      case UserRole.Tutee:
        return Colors.green;
      case UserRole.Tutor:
        return Colors.red;
    }
  }

  List<Widget> _profileCard(FirebaseUser user) {
    return [
      CircleAvatar(
        backgroundImage: user != null && user.photoUrl != null
            ? CachedNetworkImageProvider(user.photoUrl)
            : AssetImage('assets/images/avatar.png'),
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
                ]),
      Spacer(),
      user != null ? _buildSwitchRoleButton() : Container(),
    ];
  }

  Widget _buildSwitchRoleButton() {
    // return Container(
    //   child: ListTile(
    //     title: Text(
    //       'Switch to Tutor',
    //       style: TextStyle(color: Colors.red),
    //     ),
    //     onTap: () {},
    //   ),
    // );

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _userRoleColor,
        ),
        child: PopupMenuButton<UserRole>(
          padding: EdgeInsets.all(0),
          offset: Offset(80, 120),
          initialValue: widget.model.userRole,
          onSelected: (UserRole val) {
            setState(() => _userRoleColor = _getUserRoleColor(val));
            widget.model.changeUserRole(val);
          },
          child: Text(widget.model.userRole.toString().split('.')[1], style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
          itemBuilder: (_) {
            return UserRole.values
                .map<PopupMenuEntry<UserRole>>((UserRole val) {
              return PopupMenuItem<UserRole>(
                value: val,
                child: Text(val.toString().split('.')[1],
                    style: TextStyle(fontWeight: FontWeight.w600)),
              );
            }).toList();
          },
        ));
  }

  @override
  void initState() {
    print(widget.model.userRole);
    _userRoleColor = _getUserRoleColor(widget.model.userRole);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: ListView(
        children: <Widget>[
          // User Information
          InkWell(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: Row(
                    children: _profileCard(widget.model.authenticatedUser))),
            onTap: () => Navigator.pushNamed(
                context,
                widget.model.authenticatedUser == null
                    ? '/auth'
                    : '/user/info'),
          ),
          Divider(height: 1),

          Divider(height: 1),
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
          widget.model.userRole == UserRole.Parent ? ListTile(
              leading: Icon(Icons.person, color: Colors.orangeAccent),
              title: Text('My Children'),
              onTap: () => Navigator.pushNamed(context, '/child/view')) : Container(),
          ListTile(
            leading: Icon(Icons.history, color: Colors.redAccent),
            title: Text('Payment History'),
            onTap: () => {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Share to friend'),
            onTap: () => Share.share(
                "TUTU - the best tutor matching app in Hong Kong - http://tutuapp.hk - join us now!"),
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
  final MainModel model;

  MyInformationPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _MyInformationPageState();
  }
}
