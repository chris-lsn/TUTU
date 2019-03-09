import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../scoped-models/main.dart';

class SlideMenu extends StatelessWidget {
  final MainModel model;

  SlideMenu(this.model);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(0),
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountEmail: Text(model.authenticatedUser.email),
                accountName: Text(model.authenticatedUser.displayName),
                currentAccountPicture: CircleAvatar(
                  backgroundImage:
                      NetworkImage(model.authenticatedUser.photoUrl),
                ),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/slideMenu_bg.jpg'),
                        fit: BoxFit.cover)),
              ),
              ListTile(
                title: Text("Home"),
                trailing: Icon(Icons.home),
                onTap: () {
                  print("Home");
                },
              ),
              ListTile(
                title: Text("Notification"),
                trailing: Icon(Icons.notifications),
                onTap: () {
                  print("Notification");
                },
              ),
            ],
          ),
        ),
        SafeArea(
          child: ListTile(
            title: Text("Logout"),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      title: Text('Are you sure you want to logout?'),
                      actions: <Widget>[
                        CupertinoButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('No')),
                        CupertinoButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Yes')),
                      ],
                    );
                  });
            },
          ),
        )
      ],
    ));
  }
}
