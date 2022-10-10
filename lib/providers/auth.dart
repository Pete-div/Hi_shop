import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  Timer? _authTimer;
  DateTime? _expiryDate;
  String?  _token;
  String? _userId;

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

  String? get userId{
    return _userId;
  }



  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/$urlSegment?key=AIzaSyAkvO5Wg8Qz5AFQAR4cyNf1Aa0LW8kOV60');

    try {
      final response = await http.post(
        url,
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}),
      );
      final responseData = json.decode(response.body);
   
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
     
      autoLogOut();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData =json.encode({
        'token':_token, 
        'userId':_userId,
        'expiryDate':_expiryDate!.toIso8601String()});
prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'accounts:signUp');
  }

  Future<void> logIn(String email, String password) async {
    return _authenticate(email, password, 'accounts:signInWithPassword');
  }

Future<bool> tryAutoLogin()async{
  final prefs = await SharedPreferences.getInstance();
  if(!prefs.containsKey('userData')){
    return false;
  }
  final extractedUserData = json.decode(prefs.getString('userData')! ) as Map<String,Object>;
final expiryDate = DateTime.parse(extractedUserData['expiryDate'].toString()) ;
if(expiryDate.isBefore(DateTime.now())){
return false;
}

_token= extractedUserData['token'].toString();
_userId = extractedUserData['userId'].toString();
_expiryDate = expiryDate;
notifyListeners();
autoLogOut();
return true;
}


  Future<void> logOut()async{
    _expiryDate = null ;
    _token = null;
    _userId = null;
    if(_authTimer != null){
      _authTimer!.cancel();
      _authTimer = null ;
    }
    notifyListeners();
final prefs = await SharedPreferences.getInstance();
 prefs.clear();
 // prefs.remove('userData');
//  if we have files we dot want to remove while we clear this app, we use prefs.remove
  }

  

  void autoLogOut(){
    if(_authTimer != null){
      _authTimer!.cancel();
    }
    final timeExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
   _authTimer = Timer(Duration(seconds:timeExpiry ), logOut);
  }
}
