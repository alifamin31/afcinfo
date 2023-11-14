import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:afcinfo/authentication/login.dart';
import 'package:afcinfo/home.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashService {
  List<dynamic>? storedData;

  final storage = const FlutterSecureStorage();
  
  var _email;
  var _password;
  var _data;
  
  void keepLogin(BuildContext context) async {
    _email = await storage.read(key: 'email');
    _password = await storage.read(key: 'password');
    _data = await storage.read(key: 'data');
    if(_email != null && _password != null) {
      final response = await http.post(
          Uri.parse('127.0.0.1:8000/api/afc_info/login'),
          body: {
            'email' : _email,
            'password' : _password,
          }
      );
      if(response.statusCode == 200) {
        final login = jsonDecode(response.body);
        String data = jsonEncode(login);
        if(login == 'Email Do Not Exist') {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const LoginPage()));
        } else if(login == 'Wrong Password. Please Try Again') {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const LoginPage()));
        } else {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(data: login,)));
        }
      }
    } else {
      Timer(const Duration(seconds: 3), () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const LoginPage()));
      });
    }
  }
}