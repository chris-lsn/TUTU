import 'dart:ui';
import 'package:scoped_model/scoped_model.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';

import '../models/resultHandler.dart';
import '../models/auth.dart';
import '../scoped-models/main.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final Map<String, dynamic> _formData = {'name': null, 'email': null, 'password': null, 'acceptTerms': false};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  Widget _buildDisplayNameTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Displayed Name',
        filled: true,
        prefixIcon: Icon(
          Icons.person,
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Displayed name cannot be empty';
        }
      },
      onSaved: (String value) {
        _formData['name'] = value;
      },
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        hintText: "Enter an email",
        labelText: 'E-Mail',
        prefixIcon: Icon(
          Icons.email,
        ),
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
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Password',
        filled: true,
        prefixIcon: Icon(
          Icons.vpn_key,
        ),
      ),
      obscureText: true,
      controller: _passwordTextController,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password invalid';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Confirm Password', filled: true),
      obscureText: true,
      validator: (String value) {
        if (_passwordTextController.text != value) {
          return 'Passwords do not match.';
        }
      },
    );
  }

  Widget _buildAcceptCheckbox() {
    return Row(
      children: <Widget>[
        Checkbox(
          value: _formData['acceptTerms'],
          onChanged: (bool value) {
            setState(() {
              _formData['acceptTerms'] = value;
            });
          },
        ),
        Text(
          'I agree to the terms & conditions',
          style: TextStyle(fontSize: 14.0),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Forget Password',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {},
            )
          ],
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 40),
                        child: Text(
                          '${_authMode == AuthMode.Login ? 'Login' : 'Signup'}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
                        ),
                      ),
                      _authMode == AuthMode.Signup ? _buildDisplayNameTextField() : Container(),
                      SizedBox(
                        height: 15,
                      ),
                      _buildEmailTextField(),
                      SizedBox(
                        height: 15,
                      ),
                      _buildPasswordTextField(),
                      SizedBox(
                        height: 15,
                      ),
                      _authMode == AuthMode.Signup ? _buildPasswordConfirmTextField() : Container(),
                      _authMode == AuthMode.Signup ? _buildAcceptCheckbox() : Container(),
                      SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: InkWell(
                            child: Text('${_authMode == AuthMode.Login ? 'Not registered yet?' : 'Already have an account?'}',
                                style: TextStyle(color: Colors.blue)),
                            onTap: () {
                              setState(() {
                                _authMode == AuthMode.Login ? _authMode = AuthMode.Signup : _authMode = AuthMode.Login;
                              });
                            }),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      ScopedModelDescendant<MainModel>(
                        builder: (BuildContext context, Widget child, MainModel model) {
                          return SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: RaisedButton(
                              child: Text("Submit", style: TextStyle(color: Colors.white, fontSize: 16)),
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();

                                  if (_authMode == AuthMode.Login) {
                                    ResultHandler authResult = await model.login(_formData['email'], _formData['password']);
                                    if (authResult.isSuccess) {
                                      Navigator.pop(context);
                                    } else {
                                      Scaffold.of(context).showSnackBar(SnackBar(content: Text(authResult.err_message.toString())));
                                    }
                                  } else if (_authMode == AuthMode.Signup && _formData['acceptTerms']) {
                                    model.signup(name: _formData['name'], email: _formData['email'], password: _formData['password']);
                                  }
                                }
                              },
                            ),
                          );
                        },
                      )
                    ],
                  )),
            )));
  }
}
