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

  void toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }
}

mixin CasesModel on ConnectedModel {}

mixin UtilityModel on ConnectedModel {
  bool get isLoading => _isLoading;
  void set isLoading(bool result) => _isLoading = result;

}

mixin UserModel on ConnectedModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser get authenticatedUser => _authenticatedUser;
  void set authenticatedUser(FirebaseUser user) => _authenticatedUser = user;

  bool get isLoggedIn => _authenticatedUser != null;
  FirebaseAuth get auth => _auth;

  Future<ResultHandler> login(String email, String password) async {
    try {
      toggleLoading();
      _authenticatedUser = await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on PlatformException catch (error) {
      toggleLoading();
      return ResultHandler(isSuccess: false, err_message: ErrorMessage(error.code));
    }
    toggleLoading();
    return ResultHandler(isSuccess: true);
  }

  Future<ResultHandler> signup({String name, String email, String password}) async {
    try {
      toggleLoading();
      _authenticatedUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on PlatformException catch (error) {
      toggleLoading();
      return ResultHandler(isSuccess: false, err_message: ErrorMessage(error.code));
    }
    await _authenticatedUser.sendEmailVerification();
    await updateProfile(name, null);
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
    if (password.isNotEmpty) await _authenticatedUser.updatePassword(password);
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
    toggleLoading();
  }

  Future<ResultHandler> resetPassword(String email) async {
    try {
      toggleLoading();
      await _auth.sendPasswordResetEmail(email: email);
      toggleLoading();
    } on PlatformException catch (error) {
      toggleLoading();
      return ResultHandler(isSuccess: false, err_message: ErrorMessage(error.code));
    }
    return ResultHandler(isSuccess: true);
  }

  Future<void> logout(Function cb) async {
    await _auth.signOut();
    _authenticatedUser = null;
    cb();
    notifyListeners();
  }

  void sendEmailVerification() async => (await _auth.currentUser()).sendEmailVerification();
}
