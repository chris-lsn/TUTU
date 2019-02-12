import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../components/appbars.dart';
import '../../scoped-models/main.dart';

class UserInfoPageState extends State<UserInfoPage> {
  Widget _buildProfileRow({String label, String value, bool showArrow}) {
    return Container(
      color: Colors.white,
      child: ListTile(
        title: TextFormField(
          enabled: false,
          initialValue: value,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
        ),
        trailing: showArrow ? Icon(Icons.keyboard_arrow_right) : null,
      ),
    );
  }

  Widget _buildLogoutRow({Function onPressFunc}) {
    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text(
          'Logout',
          style: TextStyle(color: Colors.red),
        ),
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  contentPadding: EdgeInsets.only(top: 10.0),
                  content: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                            Text('Confirmation', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),),
                            SizedBox(height: 20.0,),
                            Text('Are you sure you want to logout?')
                          ],)
                        ),
                        SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          height: 50.0,
                          child: RaisedButton(
                              color: Colors.red[500],
                              child: Text(
                                'YES',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                
                                await onPressFunc(() {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });
                              }),
                        )
                      ]),
                );
              });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: GeneralAppBar(title: 'Edit Account'),
      body: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return model.authenticatedUser != null ? Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: ListView(
                children: <Widget>[
                  _buildProfileRow(label: 'Display Name', value: model.authenticatedUser.displayName, showArrow: true),
                  Divider(height: 1),
                  _buildProfileRow(label: 'Email', value: model.authenticatedUser.email, showArrow: true),
                  Divider(height: 1),
                  _buildProfileRow(label: 'Password', value: '******', showArrow: true),
                  Divider(height: 1),
                  _buildLogoutRow(onPressFunc: model.logout)
                ],
              )) : Container();
        },
      ),
    );
  }
}

class UserInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserInfoPageState();
  }
}
