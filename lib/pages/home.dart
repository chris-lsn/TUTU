import "package:flutter/material.dart";
import '../components/appbar.dart';
import '../components/navbar.dart';
import '../components/slideMenu.dart';

import './home/searchCase.dart';
import './home/myCase.dart';
import './home/myInformation.dart';

class HomePageState extends State<HomePage> {
  int _currentIndex;

  HomePageState() {
    this._currentIndex = 1;
  }

  List<Widget> _children = [
    MyCasePage(),
    SearchCasePage(),
    MyInformationPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CustomNavbar((int index) {
          setState(() {
            _currentIndex = index;
          });
        }, _currentIndex),
        appBar: CustomAppBar(
            title: 'tutu', titleStyle: TextStyle(fontFamily: 'MajorMono'), action: true),
        endDrawer: SlideMenu(),
        body: IndexedStack(
          index: _currentIndex,
          children: _children,
        ));

        
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }
}
