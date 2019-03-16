import 'package:flutter/material.dart';

class SubjectList extends StatelessWidget {
  final List<String> subjects;

  SubjectList(this.subjects);
  
  @override
  Widget build(BuildContext context) {
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
