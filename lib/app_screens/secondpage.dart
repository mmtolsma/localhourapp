import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swapi_project/components/expandable-list-item.dart';

class SecondPage extends StatefulWidget {
  @override
  SecondPageState createState() => SecondPageState();
}

class SecondPageState extends State<SecondPage> {
  final String url = 'https://local.ponelat.com';
  List specials;

  @override
  void initState() {
    //initial state of this widget i.e. initialisation of the widget
    super.initState(); //super is used to call the constructor of the BASE/PARENT class
    this.getSpecials().then((jsonSpecials) {
      setState(() {
        specials = jsonSpecials;
      });
    }); //load the json data
  }

  Future<List> getSpecials() async {
    var response = await http.get(
        //Encode the url
        Uri.encodeFull(url + '/specials'),
        //only accept Json response
        headers: {"Accept": "application/json"});
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    var secondPageBody;

    if (specials == null) {
      secondPageBody = loadingBar();
    } else {
      secondPageBody = listOfSpecies();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Star Wars Species"),
        backgroundColor: Colors.green,
      ),
      body: secondPageBody,
    );
  }

  Widget loadingBar() {
    return Center(
        child: Text(
      "Finding specials...",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 40.0,
      ),
    ));
  }

  Widget listOfSpecies() {
    return ListView.builder(
      itemCount: specials == null ? 0 : specials.length,
      itemBuilder: (BuildContext context, int index) {
        return speciesListItem(index);
      },
    );
  }

  Widget speciesListItem(int index) {
    return ExpandableListItem(
      summary: specials[index]['specialSummary'],
    );
  }
}
