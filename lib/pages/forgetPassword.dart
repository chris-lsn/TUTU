import 'dart:async';

import 'package:flutter/material.dart';

import '../components/buttons.dart';
import '../components/appbars.dart';
import '../models/auth.dart';
import '../models/resultHandler.dart';
import '../scoped-models/main.dart';

class ForgetPasswordState extends State<ForgetPasswordPage> {
  int _count = -1;
  String _email;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'E-Mail',
        border: InputBorder.none,
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  void _startTimer() {
    _count = 30;
    const oneSec = const Duration(seconds: 1);
    Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              _count < 1 ? timer.cancel() : _count -= 1;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GeneralAppBar(authMode: AuthMode.ForgetPassword),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      ListTile(title: _buildEmailTextField(), leading: Icon(Icons.email)),
                      SizedBox(height: 15),
                      LoadingButton(
                        name: 'Reset ${_count > 0 ? '('+ _count.toString() + ')' : ''}',
                        onPress: _count > 0 ? null : (BuildContext context, MainModel model) async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            ResultHandler result = await model.resetPassword(_email);
                            if (result.isSuccess) {
                              _startTimer();
                              Scaffold.of(context).showSnackBar(SnackBar(content: Text("An password reset have been sent to your email")));
                            } else {
                              Scaffold.of(context).showSnackBar(SnackBar(content: Text(result.err_message.toString())));
                            }
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            )));
  }
}

class ForgetPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ForgetPasswordState();
  }
}
