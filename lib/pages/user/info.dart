import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../components/appbars.dart';
import '../../pages/common/updateTextfield.dart';
import '../../scoped-models/main.dart';

enum UserInfoTextField { DISPLAY_NAME, EMAIL, PASSWORD }

class UserInfoPageState extends State<UserInfoPage> {
  Widget _buildAvatarIcon(String avatar, Function updateAvatar) {
    return Container(
        height: 100.0,
        padding: const EdgeInsets.only(left: 20),
        child: InkWell(
          enableFeedback: false,
          onTap: () {
            File _image;
            showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                          title: Center(child: Text('Take Photo')),
                          onTap: () async {
                            _image = await ImagePicker.pickImage(
                                source: ImageSource.camera, maxHeight: 150);
                            if (_image != null) {
                              Navigator.pop(context);
                              await updateAvatar(image: _image);
                            }
                          }),
                      Divider(
                        height: 1,
                      ),
                      ListTile(
                          title: Center(child: Text('Choose from gallery')),
                          onTap: () async {
                            _image = await ImagePicker.pickImage(
                                source: ImageSource.gallery, maxHeight: 150);
                            if (_image != null) {
                              Navigator.pop(context);
                              await updateAvatar(image: _image);
                            }
                          }),
                      ListTile(
                          title: Center(child: Text('View photo')),
                          onTap: () async {
                            _image = await ImagePicker.pickImage(
                                source: ImageSource.gallery, maxHeight: 150);
                            if (_image != null) {
                              Navigator.pop(context);
                              await updateAvatar(image: _image);
                            }
                          }),
                      ListTile(
                        title: Center(child: Icon(Icons.close)),
                        onTap: () => Navigator.pop(context),
                      )
                    ],
                  );
                });
          },
          child: Stack(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(0.0),
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: avatar != null ? CachedNetworkImageProvider(avatar) :AssetImage('assets/images/avatar.png'),
                    
                  ),
                  width: 90.0,
                  height: 90.0,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  )),
              Positioned(
                width: 25.0,
                bottom: -3.0,
                left: 2,
                child: CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 17.0,
                    )),
              ),
            ],
          ),
        ));
  }

  Widget _buildProfileRow(
      {UserInfoTextField key, String label, String value, Function update}) {
    final TextEditingController _textController = TextEditingController();
    _textController.text = value;

    return Container(
      color: Colors.white,
      child: ListTile(
        onTap: () => Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute<bool>(
                fullscreenDialog: true,
                builder: (BuildContext context) => UpdateTextFieldPage(
                      updateFunc: update,
                      textController: _textController,
                      buttonText: label,
                      textfield: TextFormField(
                          controller: _textController,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: label,
                          )),
                    ),
              ),
            ),
        title: TextFormField(
          enabled: false,
          controller: _textController,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
        ),
        trailing: Icon(Icons.keyboard_arrow_right),
      ),
    );
  }

  Widget _buildLogoutRow({Function onPressFunc}) {
    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text(
          'Logout',
          style: TextStyle(color: Colors.red),
        ),
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  contentPadding: EdgeInsets.only(top: 10.0),
                  content: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 30.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Confirmation',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Text('Are you sure you want to logout?')
                              ],
                            )),
                        SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          height: 50.0,
                          child: RaisedButton(
                              color: Colors.red[500],
                              child: Text(
                                'YES',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                await onPressFunc(() {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });
                              }),
                        )
                      ]),
                );
              });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GeneralAppBar(title: 'Edit Account'),
        body: ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
          return Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.symmetric(vertical: 40),
              child: ListView(
                children: <Widget>[
                  _buildAvatarIcon(
                      model.authenticatedUser.photoUrl, model.updateProfile),
                  SizedBox(height: 20),
                  _buildProfileRow(
                    key: UserInfoTextField.DISPLAY_NAME,
                    update: (String displayName) =>
                        model.updateProfile(name: displayName),
                    label: 'Display Name',
                    value: model.authenticatedUser.displayName,
                  ),
                  Divider(height: 1),
                  _buildProfileRow(
                    key: UserInfoTextField.EMAIL,
                    update: (String email) =>
                        model.updateCredentials(email: email),
                    label: 'Email',
                    value: model.authenticatedUser.email,
                  ),
                  Divider(height: 1),
                  _buildProfileRow(
                      key: UserInfoTextField.PASSWORD,
                      update: (String password) =>
                          model.updateCredentials(password: password),
                      label: 'Password',
                      value: '******'),
                  Divider(height: 1),
                  _buildLogoutRow(onPressFunc: model.logout)
                ],
              ));
        }));
  }
}

class UserInfoPage extends StatefulWidget {
  final MainModel model;

  UserInfoPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return UserInfoPageState();
  }
}
