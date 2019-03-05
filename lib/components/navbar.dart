import 'package:flutter/material.dart';

class CustomNavbar extends StatelessWidget {
  final List<BottomNavigationBarItem> bottomBarItems = [];

  final TextStyle itemStyle = TextStyle(fontWeight: FontWeight.normal);

  final HomeCb cb;
  final int currentIndex;

  CustomNavbar(this.cb, this.currentIndex) {
    bottomBarItems.add(BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text(
          "My Case",
          style: itemStyle,
        )));
    bottomBarItems.add(BottomNavigationBarItem(
        icon: Icon(Icons.search),
        title: Text(
          "Search",
          style: itemStyle,
        )));
    bottomBarItems.add(BottomNavigationBarItem(
        icon: Icon(Icons.person),
        title: Text(
          "Profile",
          style: itemStyle,
        )));
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 15,
      child: Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.blue, splashColor: Colors.blue),
          child: BottomNavigationBar(
              fixedColor: Colors.blue, onTap: _onTabTapped, currentIndex: currentIndex, items: bottomBarItems, type: BottomNavigationBarType.fixed)),
    );
  }

  _onTabTapped(int index) => cb(index);
}

typedef HomeCb = void Function(int index);
