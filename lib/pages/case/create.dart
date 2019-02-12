import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './create/subjectList.dart';
import '../../components/appbars.dart';

class CreateCaseFormState extends State<CreateCaseForm> {
  final _formKey = GlobalKey<FormState>();

  DocumentSnapshot _selectedChild;
  String _selectedChildId;

  Map<String, List<String>> _subject_list = {
    '幼稚園': ['全科', '升小面試練習', '故事班'],
    '小學': [
      '全科',
      '中國語文',
      '英國語文',
      '數學',
      '常識',
      '音樂',
      '視覺藝術',
      '體育',
      '普通話',
      '電腦',
      '奧數',
      '劍橋英語'
    ],
    '中學': [
      '中國語文',
      '英國語文',
      '數學',
      '通識教育',
      '中國文學',
      '生物',
      '企業、會計與財務概論',
      '英語文學',
      '化學',
      '設計與應用科技',
      '中國歷史',
      '物理',
      '健康管理與社會關懷',
      '經濟',
      '科學: 組合科學',
      '資訊及通訊科技',
      '倫理與宗教',
      '科學: 綜合科學',
      '科技與生活',
      '地理',
      '音樂',
      '歷史',
      '視覺藝術',
      '旅遊與款待',
      '體育'
    ],
    '大專程度': ['其他'],
    '大學程度': ['其他']
  };

List<DocumentSnapshot> _children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HomeAppBar(title: 'Create Case', action: false),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        StreamBuilder<QuerySnapshot>(
                            stream: Firestore.instance
                                .collection('children')
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError)
                                return new Text('Error: ${snapshot.error}');
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return new Text('Loading...');
                                default:
                                  _children = snapshot.data.documents;
                                  return FormField<String>(
                                    builder: (FormFieldState<String> state) {
                                      return InputDecorator(
                                        decoration: InputDecoration(
                                          labelText: 'Select a Child',
                                        ),
                                        isEmpty: _selectedChildId == '',
                                        child: new DropdownButtonHideUnderline(
                                          child: new DropdownButton<String>(
                                              value: _selectedChildId,
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  _selectedChildId = newValue;
                                                  _selectedChild = snapshot.data.documents.singleWhere((document) => document.documentID == newValue, orElse: () => null);
                                                  state.didChange(newValue);
                                                });
                                              },
                                              items: snapshot.data.documents
                                                  .map((DocumentSnapshot
                                                      document) {
                                                return new DropdownMenuItem(
                                                  value: document.documentID,
                                                  child: Text(
                                                      document['firstName'] +
                                                          ' ' +
                                                          document['lastName']),
                                                );
                                              }).toList()),
                                        ),
                                      );
                                    },
                                  );
                              }
                            }),
                        SizedBox(height: 20,),
                        Text("Tuturing Subject"),
                        RaisedButton(
                            child: Text('Choose subject'),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SubjectList(
                                        _subject_list[_selectedChild['educational_stage']]))))
                      ],
                    )),
              )
            ],
          ),
        ));
  }
}

class CreateCaseForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CreateCaseFormState();
  }
}
