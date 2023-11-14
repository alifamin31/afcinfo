import 'dart:convert';

import 'package:afcinfo/widget/bottombar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.data}) : super(key: key);
  final data;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var countryName;
  var squad;

  @override
  void initState() {
    setState(() {
      countryName = widget.data['country'];
    });
    print('sdsdsd $countryName');
    _callSquad();
    super.initState();
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

  Future<void> _callSquad() async {
    final response = await http.post(
      Uri.parse('http://192.168.1.114:8000/api/afc_info/get_squads'),
      body: {
        'country_name' : countryName,
      }
    );
    if(response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> squads = responseData['squads'];

      setState(() {
        squad = squads;
      });
      print('lslsal ${squad}');
    } else {
      showDialog(
          context: context,
          builder: (context){
            return const AlertDialog(
              content: Text('No Internet'),
            );
          }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'AFC Info',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.indigo.shade900,
        ),
        body: Container(
          child: Column(
            children: [
              Text(
                countryName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: squad != null ? squad.length : 0,
                  itemBuilder: (BuildContext context, int index) {
                    final squadList = squad[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text('${squadList['player_name']}'),
                                          leading: Text('${squadList['jersey_number']}'),
                                          subtitle: Text('${squadList['position']}'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomBar(homeSize: 50, countrySize: 40, data: widget.data),
      ),
    );
  }
}
