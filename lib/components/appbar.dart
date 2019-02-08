import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  TextStyle titleStyle = TextStyle();
  bool action = false;
  
  CustomAppBar({Key key, @required this.title, this.titleStyle, this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new AppBar(
      title: Text(
        title,
        style: titleStyle,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: true,
      actions: action? <Widget>[
        new IconButton(
          icon: new Icon(Icons.filter_list),
        onPressed: () => Scaffold.of(context).openEndDrawer(),
        ),
      ] : null,
      // leading: IconButton(
      //   tooltip: 'Menu',
      //   icon: const Icon(Icons.menu),
      //   onPressed: () => Scaffold.of(context).openDrawer(),
      // ),

    );
  }

  // @override
  // // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
