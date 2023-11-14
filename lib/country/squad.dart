import 'dart:convert';
import 'package:afcinfo/widget/bottombar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SquadList extends StatefulWidget {
  const SquadList({Key? key, this.data, this.countryName}) : super(key: key);
  final data;
  final countryName;

  @override
  State<SquadList> createState() => _SquadListState();
}

class _SquadListState extends State<SquadList> {

  var squad;

  @override
  void initState() {
    _callSquad();
    super.initState();
  }

  Future<void> _callSquad() async {
    final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/afc_info/get_squads'),
        body: {
          'country_name' : widget.countryName,
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
    return Scaffold(
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
              widget.countryName,
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
      bottomNavigationBar: BottomBar(homeSize: 40, countrySize: 50, data: widget.data),
    );
  }
}
