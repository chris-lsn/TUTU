import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';

class UserInfoPageState extends State<UserInfoPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('My Infomation'),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return ListView(
          children: <Widget>[
            RaisedButton(child: Text('Logout'), onPressed: () {
              model.logout();
              Navigator.pop(context);
            },)
          ],
        );
        },
      ),
    );
  }
}

class UserInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UserInfoPageState();
  }
}
