import 'package:flutter/material.dart';

class SubjectList extends StatelessWidget {
  List<String> subjects;
  SubjectList(this.subjects);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Subject'),
        centerTitle: true,
      ),
      body: ListView(
        children: subjects.map((subject) {
          return ListTile(title: Text(subject),);
        }).toList()
      ),
    );
  }
}
