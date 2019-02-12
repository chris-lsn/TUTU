import 'package:flutter/material.dart';
import '../models/auth.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  TextStyle titleStyle = TextStyle();
  bool action = false;

  HomeAppBar({Key key, @required this.title, this.titleStyle, this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: titleStyle,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: true,
    );
  }

  // @override
  // // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class GeneralAppBar extends StatelessWidget implements PreferredSizeWidget {
  String _title = "";
  AuthMode _authMode;

  GeneralAppBar({AuthMode authMode, String title}) {
    if (authMode != null) {
      _authMode = authMode;
      if (authMode == AuthMode.Login)
        _title = "Login";
      else if (authMode == AuthMode.Signup)
        _title = "Signup";
      else if (authMode == AuthMode.ForgetPassword) 
      _title = "Reset Password";
    } else {
      _title = title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          alignment: Alignment.bottomLeft,
          child: Text(_title, style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ),
      actions: <Widget>[
        _authMode == AuthMode.Login
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
