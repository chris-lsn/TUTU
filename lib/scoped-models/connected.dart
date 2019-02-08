import 'dart:io';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

mixin ConnectedModel on Model {
  bool _isLoading = false;
  FirebaseUser _authenticatedUser;
}

mixin CasesModel on ConnectedModel {}

mixin UtilityModel on ConnectedModel {
  bool get isLoading => _isLoading;
}

mixin UserModel on ConnectedModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser get authenticatedUser => _authenticatedUser;

  bool get isLoggedIn => _authenticatedUser != null;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      _authenticatedUser = await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on PlatformException catch (error) {
      String err_message;
      if (error.code == 'ERROR_USER_NOT_FOUND') {
        err_message = 'Wrong E-mail or Password.';
      } else if (error.code == 'ERROR_USER_DISABLED') {
        err_message = 'Your account has been disabled';
      }
      return {'result': false, 'err_message': err_message};
    }
    notifyListeners();
    return {'result': true};
  }

  void signup(String name, String email, String password, File image) async {
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    UserUpdateInfo info = new UserUpdateInfo();
    info.displayName = name;
    if (image != null) {
      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('/user/${user.uid}/profile_pic.jpg');
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
      String photoUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      info.photoUrl = photoUrl;
    }
    user.updateProfile(info);
    await user.sendEmailVerification();
    await user.reload();
    _authenticatedUser = user;
    notifyListeners();
  }

  void logout() async {
    await _auth.signOut();
    _authenticatedUser = null;
    notifyListeners();
  }

  void sendEmailVerification() async => (await _auth.currentUser()).sendEmailVerification();
}
