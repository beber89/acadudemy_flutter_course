import 'package:acadudemy_flutter_course/models/auth.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import "dart:async";
import "dart:convert";
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:acadudemy_flutter_course/models/user.dart';
import 'http_bloc.dart';

class AuthBloc with HttpBloc {
  String _apiKey;
  User _authenticatedUser;

  var _authenticatedUserStateController = BehaviorSubject<User>();
  StreamSink<User> get _userSink => _authenticatedUserStateController.sink;
  Stream<User> get userStream => _authenticatedUserStateController.stream;
  var _uiLoadStateController = BehaviorSubject<bool>();
  StreamSink<bool> get _uiLoadSink =>
      _uiLoadStateController.sink;
  Stream<bool> get uiLoadStream => _uiLoadStateController.stream;

  AuthBloc() {
    rootBundle.loadString('assets/config.json').then((String str) {
      _apiKey = json.decode(str)["api_key"];
    });
    autoAuthenticate();
  }
  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    if (token != null) {
      ensureTokenIsValid(token).then((isValid) {
        if (!isValid) {
          logout();
        } else {
          final String userEmail = prefs.getString('userEmail');
          final String userId = prefs.getString('userId');
          _authenticatedUser = User(id: userId, email: userEmail, token: token);
          _userSink.add(_authenticatedUser);
        }
      });
    } else {
      _userSink.add(null);
    }
  }

  void logout() async {
    print('Logout');
    _authenticatedUser = null;
    _userSink.add(_authenticatedUser);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=${_apiKey}',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    } else {
      response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=${_apiKey}',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong.';
    print(responseData);
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded!';
      _authenticatedUser = User(
          id: responseData['localId'],
          email: email,
          token: responseData['idToken']);
      _userSink.add(_authenticatedUser);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['idToken']);
      prefs.setString('userEmail', email);
      prefs.setString('userId', responseData['localId']);
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists.';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email was not found.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid.';
    }
    return {'success': !hasError, 'message': message};
  }

  void dispose() {
    _uiLoadStateController.close();
    _authenticatedUserStateController.close();
  }
}
