import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutor_matching_app/components/appbars.dart';
import 'package:tutor_matching_app/pages/child/add.dart';

import '../../scoped-models/main.dart';

class ViewChildPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddChildForm()));
          },
          child: Icon(Icons.add)),
      appBar: GeneralAppBar(title: 'My Children',),
      body: ScopedModelDescendant<MainModel>(
        builder: (context, child, MainModel model) {
          return StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('user')
                  .document(model.authenticatedUser.uid)
                  .collection('children')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.data.documents.isEmpty == true) {
                      return Center(child: Text('You don\'t create any child yet'),);
                    }
                    return ListView(
                        children: snapshot.data.documents.map((DocumentSnapshot document) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/avatar.png'),
                          radius: 25.0,
                        ),
                        title: Text(document['fName'] + " " +  document['lName']),
                        subtitle: Text(document['gender']),
                      );
                    }).toList());
                }
              });
        },
      ),
    );
  }
}
