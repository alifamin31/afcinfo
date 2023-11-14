import 'dart:convert';

import 'package:afcinfo/authentication/register.dart';
import 'package:afcinfo/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  final _formkey =GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();

  var _rememberme;
  var _rememberemail;
  var _rememberpassword;

  bool _isObscure3 = true;
  bool visible = false;
  bool remembermetick = false;

  @override
  void initState() {
    autofill();
    super.initState();
  }

  autofill() async {
    _rememberemail = await storage.read(key: 'rememberemail');
    _rememberpassword = await storage.read(key: 'rememberpassword');
    _rememberme = await storage.read(key: 'rememberme');
    setState(() {
      if(_rememberme == 'true') {
        remembermetick = true;
        _controllerEmail = TextEditingController(text: _rememberemail);
        _controllerPassword = TextEditingController(text: _rememberpassword);
      } else {
        _controllerEmail = TextEditingController();
        _controllerPassword = TextEditingController();
      }
    });
  }

  Future<bool> _onWillPop() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              SystemNavigator.pop();
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
    return false;
  }

  Future<void> _signin() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/afc_info/login'),
      body: {
        'email' : _controllerEmail.text,
        'password' : _controllerPassword.text,
      }
    );
    if(response.statusCode == 200) {
      final login = jsonDecode(response.body);
      String data = jsonEncode(login);
      if(login == 'Email Do Not Exist') {
        showDialog(
            context: context,
            builder: (context){
              return const AlertDialog(
                content: Text('Email Not Found'),
              );
            }
        );
      } else if(login == 'Wrong Password. Please Try Again') {
        showDialog(
            context: context,
            builder: (context){
              return const AlertDialog(
                content: Text('Wrong Password. Please Try Again'),
              );
            }
        );
      } else {
        await storage.write(key: 'email', value: _controllerEmail.text);
        await storage.write(key: 'password', value: _controllerPassword.text);
        await storage.write(key: 'data', value: data);
        if(remembermetick == true) {
          await storage.write(key: 'rememberme', value: remembermetick.toString());
          await storage.write(key: 'rememberemail', value: _controllerEmail.text);
          await storage.write(key: 'rememberpassword', value: _controllerPassword.text);
        } else {
          await storage.write(key: 'rememberme', value: remembermetick.toString());
        }
        print('object $login');
        print('object ${login['country']}');
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(data: login,)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: KeyboardDismisser(
        gestures: [
          GestureType.onTap,
          GestureType.onPanUpdateDownDirection
        ],
        child: Scaffold(
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 40.0, left: 30.0, right: 30.0, bottom: 100.0
                  ),
                ),
                Expanded(
                  child: Container(
                    child:  Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Column(
                              children: [
                                const Text(
                                  'AFC Info',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    letterSpacing: 1,
                                  ),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Colors.indigo.shade900,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
                                  ),
                                  color: const Color(0XFFE8EAF6),
                                  margin: const EdgeInsets.all(45),
                                  elevation: 9,
                                  child: Center(
                                    child: Container(
                                      margin: const EdgeInsets.all(20),
                                      child: Form(
                                        key: _formkey,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            TextFormField(
                                              controller: _controllerEmail,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText: 'Email',
                                                enabled: true,
                                                contentPadding: const EdgeInsets.only(
                                                    left: 14.0, bottom: 8.0, top: 8.0),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide:
                                                  const BorderSide(color: Colors.white),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide:
                                                  const BorderSide(color: Colors.white),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value!.length == 0) {
                                                  return "Email cannot be empty";
                                                } else {
                                                  return null;
                                                }
                                              },
                                              onSaved: (value) {
                                                _controllerEmail.text = value!;
                                              },
                                              keyboardType: TextInputType.emailAddress,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            TextFormField(
                                              controller: _controllerPassword,
                                              obscureText: _isObscure3,
                                              decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                    icon: Icon(_isObscure3
                                                        ? Icons.visibility
                                                        : Icons.visibility_off),
                                                    onPressed: () {
                                                      setState(() {
                                                        _isObscure3 = !_isObscure3;
                                                      });
                                                    }),
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText: 'Password',
                                                enabled: true,
                                                contentPadding: const EdgeInsets.only(
                                                    left: 14.0, bottom: 8.0, top: 15.0),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide:
                                                  const BorderSide(color: Colors.white),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide:
                                                  const BorderSide(color: Colors.white),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                              validator: (value) {
                                                RegExp regex = RegExp(r'^.{6,}$');
                                                if (value!.isEmpty) {
                                                  return "Password cannot be empty";
                                                }
                                                if (!regex.hasMatch(value)) {
                                                  return ("please enter valid password min. 6 character");
                                                } else {
                                                  return null;
                                                }
                                              },
                                              onSaved: (value) {
                                                _controllerPassword.text = value!;
                                              },
                                              keyboardType: TextInputType.emailAddress,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                Checkbox(
                                                  value: remembermetick,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      remembermetick = value!;
                                                    });
                                                  }
                                                ),
                                                const Text('Remember Me'),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            MaterialButton(
                                              shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                              elevation: 5.0,
                                              splashColor: const Color(0xFF1A237E),
                                              height: 40,
                                              onPressed: () {
                                                _signin();
                                              },
                                              color: Colors.indigo[900],
                                              child:  const Text(
                                                'Login  ',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  letterSpacing: 1,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextButton(
                                    onPressed: (){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegisterPage()));
                                    },
                                    child: const Text('Register')
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
