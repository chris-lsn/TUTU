import 'package:flutter/material.dart';
import '../models/modes/auth.dart';
import 'package:flutter/cupertino.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TextStyle titleStyle;
  final bool action;

  HomeAppBar(
      {Key key,
      @required this.title,
      this.titleStyle = const TextStyle(),
      this.action = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Builder(
          builder: (context) => IconButton(
                icon: Icon(CupertinoIcons.person),
                onPressed: () => Scaffold.of(context).openDrawer(),
              )),
      title: Text(
        title,
        style: titleStyle,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class GeneralAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final AuthMode authMode;

  GeneralAppBar({this.authMode, @required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          alignment: Alignment.bottomLeft,
          child:
              Text(title, style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ),
      actions: <Widget>[
        authMode == AuthMode.Login
            ? FlatButton(
                child: Text(
                  'Forget Password',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => Navigator.pushNamed(context, '/auth/forget'),
              )
            : Container()
      ],
    );
  }

  @override
  final Size preferredSize = Size.fromHeight(100.0);
}
