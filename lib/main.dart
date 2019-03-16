import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import "pages/home.dart";
import 'pages/auth.dart';
import 'pages/child/view.dart';
import 'pages/user/info.dart';
import 'pages/forgetPassword.dart';

import 'scoped-models/main.dart';

void main() {
  Firestore.instance.settings(timestampsInSnapshotsEnabled: true);
  final MainModel _model = MainModel();
  _model.autoAuthenticate();
  runApp(MyApp(_model));
}

ThemeData appTheme = ThemeData(primaryColor: Colors.blue, fontFamily: 'Oxygen');

class MyApp extends StatelessWidget {

  final MainModel model;
  MyApp(this.model);

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.grey[900],
            textTheme: TextTheme(
              title: TextStyle(fontSize: 28, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          home: ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model) => HomePage(model)),
          routes: <String, WidgetBuilder>{
            '/auth': (BuildContext context) => AuthPage(),
            '/auth/forget': (BuildContext context) => ForgetPasswordPage(),
            '/home': (BuildContext context) =>
                ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model) => HomePage(model)),
            '/child/view': (BuildContext context) => ViewChildPage(),
            '/user/info': (BuildContext context) =>
                ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model) => UserInfoPage(model))
          }),
    );
  }
}
