import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tutor_matching_app/models/modes/userRole.dart';

import '../scoped-models/main.dart';

class SideMenu extends StatefulWidget {
  final MainModel model;
  SideMenu(this.model);
  @override
  State<StatefulWidget> createState() {
    return SlideMenuState();
  }
}

class SlideMenuState extends State<SideMenu> {
  Color _userRoleColor = Colors.white;

  @override
  initState() {
    _userRoleColor = _getUserRoleColor(widget.model.userRole);
    super.initState();
  }

  Color _getUserRoleColor(UserRole userRole) {
    switch (userRole) {
      case UserRole.Parent:
        return Colors.orange;
      case UserRole.Tutee:
        return Colors.green;
      case UserRole.Tutor:
        return Colors.red;
      default:
        return null;
    }
  }

  Widget _buildSwitchRoleButton() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
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
          child: Text(
            widget.model.userRole.toString().split('.')[1],
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
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
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(0),
            children: <Widget>[
              Stack(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountEmail: Text(widget.model.authenticatedUser.email),
                    accountName:
                        Text(widget.model.authenticatedUser.displayName),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage:
                          widget.model.authenticatedUser.photoUrl != null
                              ? NetworkImage(
                                  widget.model.authenticatedUser.photoUrl)
                              : AssetImage('assets/images/avatar.png'),
                    ),
                    onDetailsPressed: () =>
                        Navigator.of(context, rootNavigator: false)
                            .pushNamed('/user/info'),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/slideMenu_bg.jpg'),
                            fit: BoxFit.cover)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, right: 10.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: _buildSwitchRoleButton(),
                    ),
                  )
                ],
              ),
              ListTile(
                title: Text("Search Case"),
                leading: Icon(Icons.search),
                onTap: () {
                  print("Home");
                },
              ),
              ListTile(
                title: Text("My Case"),
                leading: Icon(Icons.content_copy),
                onTap: () {
                  print("Home");
                },
              ),
              Divider(
                color: Colors.grey,
              ),
              ListTile(
                title: Text("My Portfolio"),
                leading: Icon(Icons.person),
                onTap: () {
                  print("Notification");
                },
              ),
              ListTile(
                  leading: Icon(Icons.person, color: Colors.orangeAccent),
                  title: Text('My Children'),
                  onTap: () => Navigator.pushNamed(context, '/child/view'))
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
