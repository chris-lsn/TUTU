import 'package:flutter/material.dart';
import '../main.dart';

class CustomNavbar extends StatelessWidget {
  final List<BottomNavigationBarItem> bottomBarItems = [];

  final BottomNavigationBarItemStyle =
      TextStyle(fontWeight: FontWeight.normal);

  HomeCb cb;
  int currentIndex;

  CustomNavbar(HomeCb this.cb, int this.currentIndex) {
    bottomBarItems.add(BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text(
          "My Case",
          style: BottomNavigationBarItemStyle,
        )));
    bottomBarItems.add(BottomNavigationBarItem(
        icon: Icon(Icons.search),
        title: Text(
          "Search",
          style: BottomNavigationBarItemStyle,
        )));
    bottomBarItems.add(BottomNavigationBarItem(
        icon: Icon(Icons.person),
        title: Text(
          "Profile",
          style: BottomNavigationBarItemStyle,
        )));
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 15 ,
      child: Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Colors.blue,
          splashColor: Colors.blue
        ),
        child:  BottomNavigationBar(
          fixedColor: Colors.blue,
          onTap: _onTabTapped,
          currentIndex: currentIndex,
          items: bottomBarItems,
          type: BottomNavigationBarType.fixed)),
    );
  }

  _onTabTapped(int index) {
    cb(index);
  }
}

typedef HomeCb = void Function(int index);