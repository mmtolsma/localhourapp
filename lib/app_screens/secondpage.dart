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
  final String url = "https://swapi.co/api/species";
  List data;

  @override
  void initState() {
    //initial state of this widget i.e. initialisation of the widget
    super.initState(); //super is used to call the constructor of the BASE/PARENT class
    this.getJsonData(); //load the json data
  }

  Future<String> getJsonData() async {
    var response = await http.get(
        //Encode the url
        Uri.encodeFull(url),
        //only accept Json response
        headers: {"Accept": "application/json"});

    print(response.body);

    setState(() {
      var convertDataToJson = jsonDecode(response.body);
      //jsonDecode: Parses the string and returns the resulting Json object.
      data = convertDataToJson["results"];
    });

    return "Success";
  }

  var _height = 100.0;
  var _width = 400.0;

  animateContainer() {
    setState(() {
      _height = _height == 100 ? 200 : 100;
      //_width = _width == 400 ? 200 : 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    var secondPageBody;

    if (data == null) {
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
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (BuildContext context, int index) {
        return speciesListItem(index);
      },
    );
  }

  var expandMap = {}; //added at end

  Widget speciesListItem(int index) {
    var name = data[index]['name'];
    //var expanded = expandMap[index]; //added at end
    //data.forEach(f)
    return ExpandableListItem(
      summary: name,
    );
  }
}
