import 'dart:io';

import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../resources/errorMessage.dart';
import '../models/resultHandler.dart';
import '../models/modes/userRole.dart';

mixin ConnectedModel on Model {
  bool _isLoading = false;
  FirebaseUser _authenticatedUser;
  UserRole _userRole = UserRole.Tutee;

  void toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }
}

mixin CasesModel on ConnectedModel {}

mixin UtilityModel on ConnectedModel {
  bool get isLoading => _isLoading;
  set isLoading(bool result) => _isLoading = result;
}

mixin UserModel on ConnectedModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser get authenticatedUser => _authenticatedUser;
  set authenticatedUser(FirebaseUser user) => _authenticatedUser = user;

  bool get isLoggedIn => _authenticatedUser != null;
  FirebaseAuth get auth => _auth;

  void changeUserRole(UserRole userRole) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setInt('userRoleIndex', userRole.index);
    _userRole = userRole;
    notifyListeners();
  }

  UserRole get userRole => _userRole;

  void autoAuthenticate() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final String token = _prefs.getString('token');
    final int userRoleIndex = _prefs.getInt('userRoleIndex');

    if (userRoleIndex != null) {
      _userRole = UserRole.values[userRoleIndex];
    }

    if (token != null) {
      _authenticatedUser = await _auth.signInWithCustomToken(token: token);
      notifyListeners();
    }
  }

  Future<ResultHandler> login(String email, String password) async {
    try {
      toggleLoading();
      _authenticatedUser = await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on PlatformException catch (error) {
      toggleLoading();
      return ResultHandler(isSuccess: false, errorMessage: ErrorMessage(error.code));
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', await _authenticatedUser.getIdToken());
    toggleLoading();
    return ResultHandler(isSuccess: true);
  }

  Future<ResultHandler> signup({String name, String email, String password}) async {
    try {
      toggleLoading();
      _authenticatedUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on PlatformException catch (error) {
      toggleLoading();
      return ResultHandler(isSuccess: false, errorMessage: ErrorMessage(error.code));
    }
    await _authenticatedUser.sendEmailVerification();
    await updateProfile(name: name);
    return ResultHandler(isSuccess: true);
  }

  Future<ResultHandler> updateCredentials({String email, String password}) async {
    if (email != _authenticatedUser.email) {
      try {
        toggleLoading();
        await _authenticatedUser.updateEmail(email);
      } on PlatformException catch (error) {
        toggleLoading();
        return ResultHandler(isSuccess: false, errorMessage: ErrorMessage(error.code));
      }
      await _authenticatedUser.sendEmailVerification();
    } else {
      return ResultHandler(isSuccess: false, errorMessage: ErrorMessage('ERROR_EMAIL_ADDRESS_IS_SAME'));
    }
    if (password.isNotEmpty) await _authenticatedUser.updatePassword(password);
    await _authenticatedUser.reload();
    _authenticatedUser = await _auth.currentUser();
    toggleLoading();
    return ResultHandler(isSuccess: true);
  }

  Future<ResultHandler> updateProfile({String name, File image}) async {
    final UserUpdateInfo info = UserUpdateInfo();
    toggleLoading();
    if (name != _authenticatedUser.displayName && name != null) info.displayName = name;
    if (image != null) {
      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('/user/${_authenticatedUser.uid}/profile_pic.jpg');
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
      String photoUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      info.photoUrl = photoUrl;
    }

    try {
      await _authenticatedUser.updateProfile(info);
    } on PlatformException catch (error) {
      toggleLoading();
      return ResultHandler(isSuccess: false, errorMessage: ErrorMessage(error.code));
    }

    _authenticatedUser = await _auth.currentUser();
    toggleLoading();
    return ResultHandler(isSuccess: true);
  }

  Future<ResultHandler> resetPassword(String email) async {
    try {
      toggleLoading();
      await _auth.sendPasswordResetEmail(email: email);
      toggleLoading();
    } on PlatformException catch (error) {
      toggleLoading();
      return ResultHandler(isSuccess: false, errorMessage: ErrorMessage(error.code));
    }
    return ResultHandler(isSuccess: true);
  }

  Future<void> logout(Function cb) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    await _auth.signOut();
    _authenticatedUser = null;
    cb();
    notifyListeners();
  }

  void sendEmailVerification() async => (await _auth.currentUser()).sendEmailVerification();
}
