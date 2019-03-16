import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutor_matching_app/components/appbars.dart';
import 'package:tutor_matching_app/components/buttons.dart';
import 'package:tutor_matching_app/mixins/sharedVarriable.dart';
import 'package:tutor_matching_app/models/resultHandler.dart';
import 'package:tutor_matching_app/scoped-models/main.dart';

class AddChildFormState extends State<AddChildForm> with SharedVarriableMixin {
  File _image;
  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> _childData = {
    'fName': null,
    'lName': null,
    'gender': null,
    'educationalStage': null,
    'gardeLevel': null
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GeneralAppBar(
          title: 'Add Child',
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
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
                        validator: (val) {
                          if (val.isEmpty) {
                            return "First Name is required";
                          }
                        },
                        onSaved: (String val) => _childData['fName'] = val,
                        decoration: InputDecoration(labelText: 'First Name'),
                      )),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                          child: TextFormField(
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Last Name is required";
                          }
                        },
                        decoration: InputDecoration(labelText: 'Last Name'),
                        onSaved: (String val) => _childData['lName'] = val,
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  FormField<String>(
                    initialValue: _childData['gender'],
                    onSaved: (val) => _childData['gender'] = val,
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
                              _childData['gender'] = newValue;
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
                    initialValue: _childData['educationalStage'],
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
                              setState(() =>
                                  _childData['educationalStage'] = newValue);
                              state.didChange(newValue);
                            },
                            items: educationalStageList.keys.map((String key) {
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
                          labelText: _childData['educationalStage'] != null
                              ? 'Grade Level'
                              : null,
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
                              setState(
                                  () => _childData['gardeLevel'] = newValue);
                              state.didChange(newValue);
                            },
                            items: _childData['educationalStage'] != null
                                ? educationalStageList[
                                        _childData['educationalStage']]
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
                  ScopedModelDescendant<MainModel>(
                    builder: (context, child, MainModel mainModel) {
return LoadingButton(
                            onPress: (BuildContext context, MainModel model) async {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                print(_childData);
                                ResultHandler result =
                                    await mainModel.createChild(_childData);
                                if (result.isSuccess == true)
                                  Navigator.pop(context);
                              }
                            },
                            name: "Add Child",
);
                    },
                  )
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
