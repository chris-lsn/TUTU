import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import "pages/home.dart";
import 'pages/auth.dart';
import 'pages/child/view.dart';
import 'pages/user/info.dart';

import 'scoped-models/main.dart';


void main() => runApp(MyApp());

ThemeData appTheme = ThemeData(primaryColor: Colors.blue, fontFamily: 'Oxygen');

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: MainModel(),
      child: MaterialApp(
          theme: ThemeData(
            primaryColor: Colors.grey[900],
            textTheme: TextTheme(
              title: TextStyle(fontSize: 28, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          home: HomePage(),
          routes: <String, WidgetBuilder>{
            '/login': (BuildContext context) => AuthPage(),
            '/home': (BuildContext context) => HomePage(),
            '/child/view': (BuildContext context) => ViewChildPage(),
            '/user/info': (BuildContext context) => UserInfoPage()
          }),
    );
  }
}
