import 'dart:convert';

import 'package:afcinfo/country/squad.dart';
import 'package:afcinfo/widget/bottombar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CountryList extends StatefulWidget {
  const CountryList({Key? key, this.data}) : super(key: key);
  final data;

  @override
  State<CountryList> createState() => _CountryListState();
}

class _CountryListState extends State<CountryList> {

  var country;

  @override
  void initState() {
    _countryList();
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

  Future<void> _countryList() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/afc_info/get_countries')
    );
    if(response.statusCode == 200) {
      country = jsonDecode(response.body);
      print(country);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'List Of Country',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.indigo.shade900,
        ),
        body: Container(
          child: Column(
            children: [

              Expanded(
                child: ListView.builder(
                  itemCount: country != null ? country.length : 0,
                  itemBuilder: (BuildContext context, int index) {
                    final countryData = country[index];
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
                                        InkWell(
                                          onTap : (){
                                            // print('objecttttttttttttt ${countryData['country_name']}');
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SquadList(data: widget.data, countryName: countryData['country_name'].toString(),)));
                                          },
                                          child: ListTile(
                                            title: Text('${countryData['country_name']}'),
                                            leading: Text('${countryData['ranking']}'),
                                          ),
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
        bottomNavigationBar: BottomBar(homeSize: 40, countrySize: 50, data: widget.data),
      ),
    );
  }
}
