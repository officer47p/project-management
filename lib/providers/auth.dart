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
      if (DateTime.now().isBefore(expiresIn)) {
        secsToExpire = expiresIn.difference(DateTime.now());
      } else {
        _userId = null;
        _authToken = null;
        _userEmail = null;
        expiresIn = null;
        secsToExpire = null;
      }
      notifyListeners();
    } catch (err) {
      // print(
      //     "From auth.dart, where I want to load the credintials from the local storage: ${err}");
      return false;
    }
  }

  Future<void> logOut(Timer taskManagerTimer) async {
    _userId = null;
    _authToken = null;
    _userEmail = null;
    expiresIn = null;
    secsToExpire = null;
    // print("Trying to cancel autoLogOutTimer");
    autoLogOutTimer.cancel();
    // print("Trying to cancel task manger timer");
    taskManagerTimer.cancel();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  void setAutoLogOut(Timer taskManagerTimer) {
    if (autoLogOutTimer != null) {
      autoLogOutTimer.cancel();
    }
    // print("Called setAutoLogOut");
    autoLogOutTimer = Timer(secsToExpire, () => logOut(taskManagerTimer));
    // print("This is the timer: $autoLogOutTimer");
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
