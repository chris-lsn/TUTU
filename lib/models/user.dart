import 'package:flutter/material.dart';

class User {
  final String name;
  final String id;
  final String email;
  final String image;
  final String token;
  final bool isEmailVerified;

  User({@required this.id, @required this.name, @required this.email, @required this.image, @required this.token, @required this.isEmailVerified});
}