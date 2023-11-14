import 'dart:convert';

import 'package:afcinfo/authentication/login.dart';
import 'package:afcinfo/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  TextEditingController _controllerFullname = TextEditingController();
  TextEditingController _controllerUsername = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  TextEditingController _controllerPasswordConfirmation = TextEditingController();
  TextEditingController _controllerCountry = TextEditingController();

  final _formkey =GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();

  bool _isObscure1 = true;
  bool _isObscure2 = true;
  bool visible = false;

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

  Future<void> _signup() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/afc_info/register'),
      body: {
        'fullname' : _controllerFullname.text,
        'username' : _controllerUsername.text,
        'email' : _controllerEmail.text,
        'password' : _controllerPassword.text,
        'country' : _controllerCountry.text,
      }
    );
    if(_controllerPassword.text == _controllerPasswordConfirmation.text) {
      if(response.statusCode == 200) {
        final register = jsonDecode(response.body);
        print(register);
        if(register == 'Email Already Exist') {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: Text('Email Already Exist'),
              );
            }
          );
        } else if(register == 'Email Is Empty') {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: Text('Email Is Empty'),
              );
            }
          );
        } else if(register == 'Fullname Is Empty') {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  content: Text('Fullname Is Empty'),
                );
              }
          );
        } else if(register == 'Username Is Empty') {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  content: Text('Username Is Empty'),
                );
              }
          );
        } else if(register == 'Password Is Empty') {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  content: Text('Password Is Empty'),
                );
              }
          );
        } else if(register == 'Country Is Empty') {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  content: Text('Country Is Empty'),
                );
              }
          );
        } else {
          await storage.write(key: 'email', value: _controllerEmail.text);
          await storage.write(key: 'password', value: _controllerPassword.text);
          await storage.write(key: 'country', value: _controllerCountry.text);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
        }
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('Password Not Match'),
          );
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: KeyboardDismisser(
        gestures: const [
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
                                              controller: _controllerFullname,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText: 'Fullname',
                                                enabled: true,
                                                contentPadding: const EdgeInsets.only(
                                                    left: 14.0, bottom: 8.0, top: 8.0),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide:
                                                  const BorderSide(
                                                      color: Colors.white
                                                  ),
                                                  borderRadius: new BorderRadius.circular(10),
                                                ),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide:
                                                  const BorderSide(
                                                      color: Colors.white
                                                  ),
                                                  borderRadius: new BorderRadius.circular(10),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value!.length == 0) {
                                                  return "Fullname cannot be empty";
                                                } else {
                                                  return null;
                                                }
                                              },
                                              onSaved: (value) {
                                                _controllerFullname.text = value!;
                                              },
                                              keyboardType: TextInputType.emailAddress,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            TextFormField(
                                              controller: _controllerUsername,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText: 'Username',
                                                enabled: true,
                                                contentPadding: const EdgeInsets.only(
                                                    left: 14.0, bottom: 8.0, top: 8.0),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide:
                                                  const BorderSide(
                                                    color: Colors.white
                                                  ),
                                                  borderRadius: new BorderRadius.circular(10),
                                                ),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide:
                                                  const BorderSide(
                                                    color: Colors.white
                                                  ),
                                                  borderRadius: new BorderRadius.circular(10),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value!.length == 0) {
                                                  return "Username cannot be empty";
                                                } else {
                                                  return null;
                                                }
                                              },
                                              onSaved: (value) {
                                                _controllerUsername.text = value!;
                                              },
                                              keyboardType: TextInputType.emailAddress,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
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
                                                  const BorderSide(
                                                    color: Colors.white
                                                  ),
                                                  borderRadius: new BorderRadius.circular(10),
                                                ),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide:
                                                  const BorderSide(
                                                    color: Colors.white
                                                  ),
                                                  borderRadius: new BorderRadius.circular(10),
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
                                              obscureText: _isObscure1,
                                              decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                    icon: Icon(_isObscure1
                                                        ? Icons.visibility
                                                        : Icons.visibility_off),
                                                    onPressed: () {
                                                      setState(() {
                                                        _isObscure1 = !_isObscure1;
                                                      });
                                                    }),
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText: 'Password',
                                                enabled: true,
                                                contentPadding: const EdgeInsets.only(
                                                    left: 14.0,
                                                    bottom: 8.0,
                                                    top: 15.0
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide:
                                                  const BorderSide(
                                                      color: Colors.white
                                                  ),
                                                  borderRadius: new BorderRadius.circular(10),
                                                ),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide:
                                                  const BorderSide(
                                                      color: Colors.white
                                                  ),
                                                  borderRadius: new BorderRadius.circular(10),
                                                ),
                                              ),
                                              validator: (value) {
                                                RegExp regex = new RegExp(r'^.{6,}$');
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
                                            TextFormField(
                                              controller: _controllerPasswordConfirmation,
                                              obscureText: _isObscure2,
                                              decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                    icon: Icon(_isObscure2
                                                        ? Icons.visibility
                                                        : Icons.visibility_off),
                                                    onPressed: () {
                                                      setState(() {
                                                        _isObscure2 = !_isObscure2;
                                                      });
                                                    }),
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText: 'Password Confirmation',
                                                enabled: true,
                                                contentPadding: const EdgeInsets.only(
                                                  left: 14.0,
                                                  bottom: 8.0,
                                                  top: 15.0
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide:
                                                  const BorderSide(
                                                    color: Colors.white
                                                  ),
                                                  borderRadius: new BorderRadius.circular(10),
                                                ),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide:
                                                  const BorderSide(
                                                    color: Colors.white
                                                  ),
                                                  borderRadius: new BorderRadius.circular(10),
                                                ),
                                              ),
                                              validator: (value) {
                                                RegExp regex = new RegExp(r'^.{6,}$');
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
                                                _controllerPasswordConfirmation.text = value!;
                                              },
                                              keyboardType: TextInputType.emailAddress,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            TextFormField(
                                              controller: _controllerCountry,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText: 'Status',
                                                enabled: true,
                                                contentPadding: const EdgeInsets.only(
                                                    left: 14.0, bottom: 8.0, top: 8.0),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide:
                                                  const BorderSide(
                                                    color: Colors.white
                                                  ),
                                                  borderRadius: new BorderRadius.circular(10),
                                                ),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide:
                                                  const BorderSide(
                                                    color: Colors.white
                                                  ),
                                                  borderRadius: new BorderRadius.circular(10),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value!.length == 0) {
                                                  return "Status cannot be empty";
                                                } else {
                                                  return null;
                                                }
                                              },
                                              onSaved: (value) {
                                                _controllerCountry.text = value!;
                                              },
                                              keyboardType: TextInputType.emailAddress,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            MaterialButton(
                                              shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0))),
                                              elevation: 5.0,
                                              splashColor: const Color(0xFF1A237E),
                                              height: 40,
                                              onPressed: () {
                                                _signup();
                                              },
                                              color: Colors.indigo[900],
                                              child: const Text(
                                                'Register  ',
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
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage()));
                                    },
                                    child: const Text('Login')
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
