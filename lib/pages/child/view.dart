import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewChildPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            // Auth..then((result) {
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) =>
            //               result ? AddChildForm() : AuthPage('login')));
            // });
          },
          child: Icon(Icons.add)),
      appBar: AppBar(
        title: Text('Manage children'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('children').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                return ListView(
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                  return new ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/avatar.png'),
                      radius: 25.0,
                    ),
                    title: new Text(
                        document['firstName'] + ' ' + document['lastName']),
                    subtitle: new Text(document['gender']),
                  );
                }).toList());
            }
          }),
    );
  }
}
