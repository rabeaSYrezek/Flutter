import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '/model/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  } 
  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    var url = Uri.parse('http://192.168.1.104:3000/auth/$urlSegment');

    Map<String, dynamic> data = {'email': email, 'password': password};
    var body = json.encode(data);

    try {
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'}, body: body);

      final responseData = json.decode(response.body);
     // print(responseData);
      if (!responseData['success']) {
        throw HttpException(message: responseData['message']);
      }
      _token = responseData['token'];
      _userId = responseData['userId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expireIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
      
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      prefs.setString('htppAppKey', userData);
    } catch (e) {
      throw e;
    }
  }

  Future<void> signup({String? email, String? password}) async {
    return _authenticate(email ?? '1', password ?? '1', 'sign-up');
  }

  Future<void> login([String? email, String? password]) async {
    return _authenticate(email ?? '1', password ?? '1', 'login');
  }

  Future<bool> tryAutoLogin() async{
    final prefs = await SharedPreferences.getInstance();
    //print("object4: ${prefs.getString('htppAppKey')}");
    if (!prefs.containsKey('htppAppKey')) {
        return false;
    }
    final  extractedUserData = json.decode(prefs.getString('htppAppKey') ?? '') ;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate'] ) ;
    if (expiryDate.isBefore(DateTime.now())) {

      return false;
    }
    _token = extractedUserData['token'] ;
       
    _userId = extractedUserData['userId'] ;

    _expiryDate = expiryDate ;
    notifyListeners();
    _autoLogout();
    return true;

  }

  Future<void> logout() async{
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer !=null) {
        _authTimer!.cancel();
        _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('htppAppKey');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer =  Timer(Duration(seconds: timeToExpiry), logout);
  }
}
