import 'package:flutter/material.dart';
import '../pages/auth.dart';
import '../pages/home.dart';
import '../pages/case/create.dart';

class SlideMenu extends StatelessWidget {
  @override
  String _district;
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: <Widget>[
          SizedBox(
            height: 80.0,
          ),
          Text('Price Range', style: TextStyle(fontSize: 18)),
          Row(
            children: <Widget>[
              Flexible(
                  child: TextField(
                    keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'From', ),
              )),
              SizedBox(
                width: 15,
              ),
              Flexible(
                  child: TextField(
                    keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'To'),
              ))
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNavigationItems(BuildContext context) {
    List<Widget> navList = [];
    List<NavigationItem> _navigationItems = [
      NavigationItem('Home', Icons.home, HomePage()),
      // NavigationItem('Login', Icons.person_pin, LoginPage()),
    ];

    for (int i = 0; i < _navigationItems.length; i++) {
      navList.add(ListTile(
        title: Text(_navigationItems[i].name),
        trailing: Icon(_navigationItems[i].icon),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => _navigationItems[i].page));
        },
      ));
    }
    return navList;
  }
}

class NavigationItem {
  final String name;
  final IconData icon;
  final Object page;

  NavigationItem(this.name, this.icon, this.page);
}
