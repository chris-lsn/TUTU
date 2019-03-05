import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddChildFormState extends State<AddChildForm> {
  File _image;
  final _formKey = GlobalKey<FormState>();
  final _txtFirstNameCtrl = TextEditingController(),
      _txtLastNameCtrl = TextEditingController();
  final _db = Firestore.instance;

  Map<String, List<String>> _educationalStageList = {
    '幼稚園': ['幼兒班 (K1)', '低班 (K2)', '高班 (K3)'],
    '小學': ['小一 (P1)', '小二 (P2)', '小三 (P3)', '小四 (P4)', '小五 (P5)', '小六(P6)'],
    '中學': ['中一 (P1)', '中二 (P2)', '中三 (P3)', '中四 (P4)', '中五 (P5)', '中六(P6)'],
    '大專程度': ['基礎文憑', '副學士', '高級文憑'],
    '大學程度': ['大一', '大二', '大三', '大四']
  };

  String _educationalStage, _gardeLevel, _gender;

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  Future<void> _createChild() async {
    DocumentReference createdChild = await _db.collection('children').add({
      'profilePic_url': '',
      'firstName': _txtFirstNameCtrl.text,
      'lastName': _txtLastNameCtrl.text,
      'gender': _gender,
      'educational_stage': _educationalStage,
      'garde_level': _gardeLevel
    });

    if (_image != null) {
      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('/user/${createdChild.documentID}/profile_pic.jpg');
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      String downloadUrl =
          await (await uploadTask.onComplete).ref.getDownloadURL();
      await _db
          .collection('children')
          .document(createdChild.documentID)
          .updateData({'profilePic_url': downloadUrl});
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Child'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
            InkWell(
              onTap: () => _getImage(),
              child: Container(
                  width: 100,
                  height: 100,
                  child: Stack(
                    children: <Widget>[
                      Center(
                          child: Stack(
                        children: <Widget>[
                          Container(
                            child: CircleAvatar(
                              backgroundImage: _image == null
                                  ? AssetImage('assets/images/avatar.png')
                                  : FileImage(_image),
                              radius: 50.0,
                            ),
                            decoration: new BoxDecoration(
                                backgroundBlendMode: BlendMode.dstATop,
                                shape: BoxShape.circle,
                                color: Colors.white
                                    .withOpacity(_image == null ? 0.2 : 1)),
                          ),
                        ],
                      )),
                      Center(
                        child: Text(
                          _image == null ? 'Add \n photo' : '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.blue[600],
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  )),
            ),
            SizedBox(
              height: 15,
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Flexible(
                          child: TextFormField(
                        controller: _txtFirstNameCtrl,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "First Name is required";
                          }
                        },
                        decoration: InputDecoration(labelText: 'First Name'),
                      )),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                          child: TextFormField(
                        controller: _txtLastNameCtrl,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Last Name is required";
                          }
                        },
                        decoration: InputDecoration(labelText: 'Last Name'),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  FormField<String>(
                    initialValue: _gender,
                    onSaved: (val) => _gender = val,
                    validator: (val) => (val == null || val.isEmpty)
                        ? 'Gender is required'
                        : null,
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          errorText: state.hasError ? state.errorText : null,
                        ),
                        isEmpty: state.value == '' || state.value == null,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: state.value,
                            isDense: true,
                            onChanged: (String newValue) {
                              if (newValue == '') {
                                newValue = null;
                              }
                              state.didChange(newValue);
                              _gender = newValue;
                            },
                            items: ['Male', 'Female'].map((val) {
                              return DropdownMenuItem(
                                value: val,
                                child: Text(val),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  FormField<String>(
                    initialValue: _educationalStage,
                    validator: (val) => (val == null || val.isEmpty)
                        ? 'Educational Stage is required'
                        : null,
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Educational Stage',
                          errorText: state.hasError ? state.errorText : null,
                        ),
                        isEmpty: state.value == '' || state.value == null,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: state.value,
                            isDense: true,
                            onChanged: (String newValue) {
                              if (newValue == '') {
                                newValue = null;
                              }
                              setState(() => _educationalStage = newValue);
                              state.didChange(newValue);
                            },
                            items:
                                _educationalStageList.keys.map((String key) {
                              return DropdownMenuItem<String>(
                                value: key,
                                child: Text(key),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  FormField<String>(
                    validator: (val) => (val == null || val.isEmpty)
                        ? 'Grade Level is required'
                        : null,
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          labelText:
                              _educationalStage != null ? 'Grade Level' : null,
                          errorText: state.hasError ? state.errorText : null,
                        ),
                        isEmpty: state.value == '' || state.value == null,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: state.value,
                            isDense: true,
                            disabledHint:
                                Text('Please select Educational stage first'),
                            onChanged: (String newValue) {
                              if (newValue == '') {
                                newValue = null;
                              }
                              setState(() => _gardeLevel = newValue);
                              state.didChange(newValue);
                            },
                            items: _educationalStage != null
                                ? _educationalStageList[_educationalStage]
                                    .map((String key) {
                                    return DropdownMenuItem<String>(
                                      value: key,
                                      child: Text(key),
                                    );
                                  }).toList()
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: RaisedButton(
                      child: Text("Add",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await _createChild();
                          print("Success");
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

class AddChildForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddChildFormState();
  }
}
