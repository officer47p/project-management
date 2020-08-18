import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_management/providers/task_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../credentials.dart';

import 'dart:convert';
import 'dart:async';

class Auth extends ChangeNotifier {
  String _userId;
  String _authToken;
  String _userEmail;
  DateTime expiresIn;
  Timer autoLogOutTimer;
  Duration secsToExpire;

  String get authToken {
    if (_authToken != null && DateTime.now().isBefore(expiresIn)) {
      return _authToken;
    } else {
      return null;
    }
  }

  String get userId {
    return _userId;
  }

  String get userEmail {
    return _userEmail;
  }

  Future<void> saveAuthData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("authData", [
      _userId,
      _authToken,
      _userEmail,
      expiresIn.toIso8601String(),
    ]);
  }

  Future<bool> loadAuthData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> authData;
    try {
      authData = prefs.getStringList("authData");
      _userId = authData[0];
      _authToken = authData[1];
      _userEmail = authData[2];
      expiresIn = DateTime.parse(authData[3]);
      notifyListeners();
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<void> logOut(Timer taskManagerTimer) async {
    _userId = null;
    _authToken = null;
    _userEmail = null;
    expiresIn = null;
    // this.autoLogOutTimer.cancel();
    taskManagerTimer.cancel();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  void setAutoLogOut(Timer taskManagerTimer) {
    if (autoLogOutTimer != null) {
      autoLogOutTimer.cancel();
    }
    autoLogOutTimer = Timer(secsToExpire, () => logOut(taskManagerTimer));
  }

  Future<void> signUp(String email, String password) async {
    http.Response res;
    Map parsedRes;
    try {
      res = await http.post(
          "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$APIKEY",
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
      parsedRes = json.decode(res.body);
      if (parsedRes["error"] != null)
        throw Exception(parsedRes["error"]["message"]);
      _userId = parsedRes["localId"];
      _authToken = parsedRes["idToken"];
      _userEmail = parsedRes["email"];
      secsToExpire = Duration(seconds: int.tryParse(parsedRes["expiresIn"]));
      expiresIn = DateTime.now()
          .add(Duration(seconds: int.tryParse(parsedRes["expiresIn"])));
      // autoLogOutSetter(int.tryParse(parsedRes["expiresIn"]));
      await saveAuthData();
    } catch (err) {
      print(err);
      throw err;
    }

    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    http.Response res;
    Map parsedRes;
    try {
      res = await http.post(
          "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$APIKEY",
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
      parsedRes = json.decode(res.body);
      if (parsedRes["error"] != null)
        throw Exception(parsedRes["error"]["message"]);
      _userId = parsedRes["localId"];
      _authToken = parsedRes["idToken"];
      _userEmail = parsedRes["email"];
      secsToExpire = Duration(seconds: int.tryParse(parsedRes["expiresIn"]));
      expiresIn = DateTime.now()
          .add(Duration(seconds: int.tryParse(parsedRes["expiresIn"])));
      // autoLogOutSetter(int.tryParse(parsedRes["expiresIn"]));
      await saveAuthData();
    } catch (err) {
      print(err);
      throw err;
    }

    notifyListeners();
  }
}
