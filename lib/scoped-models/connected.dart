import 'dart:io';

import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../resources/errorMessage.dart';
import '../models/resultHandler.dart';

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

  Future<ResultHandler> login(String email, String password) async {
    try {
      _authenticatedUser = await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on PlatformException catch (error) {
      return ResultHandler(isSuccess: false, err_message: ErrorMessage(error.code));
    }
    notifyListeners();
    return ResultHandler(isSuccess: true);
  }

  Future<ResultHandler> signup({String name, String email, String password}) async {
    FirebaseUser user;
    try {
      user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on PlatformException catch (error) {
     return ResultHandler(isSuccess: false, err_message: ErrorMessage(error.code));
    }
    await updateProfile(name, null);
    await user.sendEmailVerification();
    await user.reload();
    _authenticatedUser = user;
    notifyListeners();
    return ResultHandler(isSuccess: true);
  }

  Future<ResultHandler> updateCredentials(String email, String password) async {
    if (email != _authenticatedUser.email) {
      try {
        await _authenticatedUser.updateEmail(email);
      } on PlatformException catch (error) {
        return ResultHandler(isSuccess: false, err_message: ErrorMessage(error.code));
      }
      await _authenticatedUser.sendEmailVerification();
    }
    if (password.isNotEmpty) 
      await _authenticatedUser.updatePassword(password);
    await _authenticatedUser.reload();
    _authenticatedUser = await _auth.currentUser();
    notifyListeners();
  }

  Future<void> updateProfile(String name, File image) async {
    final UserUpdateInfo info = UserUpdateInfo();
    
    if (name != _authenticatedUser.displayName)
      info.displayName = name;
    if (image != null) {
      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('/user/${_authenticatedUser.uid}/profile_pic.jpg');
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
      String photoUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      info.photoUrl = photoUrl;
    }
    await _authenticatedUser.updateProfile(info);
    _authenticatedUser = await _auth.currentUser();
    notifyListeners();
  }

  void logout() async {
    await _auth.signOut();
    _authenticatedUser = null;
    notifyListeners();
  }

  void sendEmailVerification() async => (await _auth.currentUser()).sendEmailVerification();
}
