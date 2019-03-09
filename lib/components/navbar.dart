import 'package:flutter/material.dart';

import '../models/modes/userRole.dart';

class CustomNavbar extends StatelessWidget {
  final List<BottomNavigationBarItem> bottomBarItems = [];

  final TextStyle itemStyle = TextStyle(fontWeight: FontWeight.normal);

  final Function onTapped;
  final int currentIndex;
  final UserRole userRole;

  CustomNavbar(this.onTapped, this.currentIndex, this.userRole) {
    bottomBarItems.add(BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text(
          "My Case",
          style: itemStyle,
        )));
    if (userRole == UserRole.Tutor) {
      bottomBarItems.add(BottomNavigationBarItem(
        icon: Icon(Icons.search),
        title: Text(
          "Search",
          style: itemStyle,
        )));
    }
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
              fixedColor: Colors.blue, onTap: onTapped, currentIndex: currentIndex, items: bottomBarItems, type: BottomNavigationBarType.fixed)),
    );
  }
}
