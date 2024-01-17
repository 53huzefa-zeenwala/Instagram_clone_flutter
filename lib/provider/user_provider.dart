import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/user.dart' as model;
import '../reponsive/auth_methods.dart';

class UserProvider  with ChangeNotifier {
  model.User? _user;
  final AuthMethods _authMethods = AuthMethods();

  model.User? get getUser => _user;

  Future<void> refreshUser() async {
    print('object');
    model.User user = await _authMethods.getUserDetails();
    print(user);
    _user = user;
    notifyListeners();
  }
}