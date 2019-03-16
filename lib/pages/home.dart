import "package:flutter/material.dart";

import '../components/appbars.dart';
import '../components/navbar.dart';
import '../components/slideMenu.dart';
import '../models/modes/userRole.dart';

import '../scoped-models/main.dart';
import './home/searchCase.dart';
import './home/myCase.dart';

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Widget> _homePages;

  MyCasePage _myCasePage;
  SearchCasePage _searchCasePage;

  @override
  void initState() {
    _myCasePage = MyCasePage();
    _searchCasePage = SearchCasePage();
    super.initState();
  }

  void _buildHomePages(UserRole userRole) {
    _homePages = [_myCasePage, _searchCasePage];

    if (userRole != UserRole.Tutor) {
      _homePages.remove(_searchCasePage);
    }

    if (_currentIndex > _homePages.length - 1) _currentIndex -= 1;
  }

  @override
  Widget build(BuildContext context) {
    _buildHomePages(widget.model.userRole);
    return Scaffold(
        drawer: SideMenu(widget.model),
        bottomNavigationBar: CustomNavbar(
            (int index) => setState(() => _currentIndex = index),
            _currentIndex,
            widget.model.userRole),
        appBar: HomeAppBar(
            title: 'tutu',
            titleStyle: TextStyle(fontFamily: 'MajorMono'),
            action: true),
        body: IndexedStack(
          index: _currentIndex,
          children: _homePages,
        ));
  }
}

class HomePage extends StatefulWidget {
  final MainModel model;

  HomePage(this.model);
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}
