import 'package:afcinfo/authentication/login.dart';
import 'package:afcinfo/country/countries.dart';
import 'package:afcinfo/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BottomBar extends StatefulWidget {
  BottomBar({Key? key, this.homeSize, this.countrySize, this.data}) : super(key: key);
  double? homeSize;
  double? countrySize;
  final data;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo.shade900,
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(data: widget.data,)));
            },
            child: Icon(
              Icons.home,
              size: widget.homeSize,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 90,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CountryList(data: widget.data,)));
            },
            child: Icon(
              Icons.flag,
              size: widget.countrySize,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 90,
          ),
          InkWell(
            onTap: () async {
              await storage.delete(key: 'email');
              await storage.delete(key: 'password');
              await storage.delete(key: 'data');
              // await storage.delete(key: 'country');
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            child: Icon(
              Icons.logout,
              size: 40,
              color: Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
