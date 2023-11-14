import 'package:afcinfo/authentication/login.dart';
import 'package:afcinfo/authentication/register.dart';
import 'package:afcinfo/home.dart';
import 'package:afcinfo/splash/screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AFC Info',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}