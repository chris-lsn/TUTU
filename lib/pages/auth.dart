import 'dart:ui';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';

import '../components/appbars.dart';
import '../components/buttons.dart';
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
  final Map<String, dynamic> _formData = {'name': null, 'email': null, 'password': null};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  Widget _buildDisplayNameTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Displayed Name',
        border: InputBorder.none,
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
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Password',
        border: InputBorder.none,
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
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        border: InputBorder.none,
      ),
      obscureText: true,
      validator: (String value) {
        if (_passwordTextController.text != value || value == '') {
          return 'Passwords do not match.';
        }
      },
    );
  }

  Widget _buildDeclarationText() {
    return Center(
      child: Text(
        "By signing up, you agree to our Terms & Privacy Policy.",
        style: TextStyle(color: Colors.grey[700]),
      ),
    );
  }

  Widget _buildAuthSwitchingButton() {
    return Center(
      child: InkWell(
          child: Text('${_authMode == AuthMode.Login ? 'Not registered yet?' : 'Already have an account?'}', style: TextStyle(color: Colors.blue)),
          onTap: () {
            setState(() {
              _authMode == AuthMode.Login ? _authMode = AuthMode.Signup : _authMode = AuthMode.Login;
            });
          }),
    );
  }

  Widget _buildSubmitButton() {
    return LoadingButton(
      onPress: (BuildContext context, MainModel model) async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();

          ResultHandler authResult;
          if (_authMode == AuthMode.Login) {
            authResult = await model.login(_formData['email'], _formData['password']);
          } else if (_authMode == AuthMode.Signup) {
            authResult = await model.signup(name: _formData['name'], email: _formData['email'], password: _formData['password']);
          }

          if (authResult.isSuccess) {
              Navigator.pop(context);
            } else {
              Scaffold.of(context).showSnackBar(SnackBar(content: Text(authResult.err_message.toString())));
            }
        }
      },
      name: 'Submit',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GeneralAppBar(authMode: _authMode),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      child: _authMode == AuthMode.Signup
                          ? ListTile(
                              title: _buildDisplayNameTextField(),
                              leading: Icon(Icons.person),
                            )
                          : Container(),
                    ),
                    Divider(height: 1,),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        title: _buildEmailTextField(),
                        leading: Icon(Icons.email),
                      ),
                    ),
                    Divider(height: 1,),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        title: _buildPasswordTextField(),
                        leading: Icon(Icons.lock),
                      ),
                    ),
                    Divider(height: 1,),
                    Container(
                      color: Colors.white,
                      child: _authMode == AuthMode.Signup
                          ? ListTile(
                              title: _buildPasswordConfirmTextField(),
                              leading: Icon(Icons.lock_outline),
                            )
                          : Container(),
                    ),
                    Divider(height: 1,),
                    SizedBox(height: 25),
                    _buildAuthSwitchingButton(),
                    SizedBox(height: 50),
                    _buildSubmitButton(),
                    SizedBox(height: 20),
                    _authMode == AuthMode.Signup ? _buildDeclarationText() : Container(),
                  ],
                )),
          ),
        ));
  }
}
