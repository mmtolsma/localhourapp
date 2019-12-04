import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
    super
        .initState(); //super is used to call the constructor of the BASE/PARENT class
    this.getJsonData(); //load the json data
  }

  Future<String> getJsonData() async {
    var response = await http.get(
        //Encode the url
        Uri.encodeFull(url),
        //only accept Json response
        headers: {"Accept": "application/json"});
    //headers: Sends an HTTP GET request with the given headers to the given URL,
    //          which can be a [Uri] or a [String].
    //Go to the SWAPI website we're using:
    // Accept is the "Vary", application/json is the "Content-Type"

    print(response.body);

    setState(() {
      var convertDataToJson = jsonDecode(response.body);
      //jsonDecode: Parses the string and returns the resulting Json object.
      data = convertDataToJson["results"];
    });

    return "Success";
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
    return Text(
      "Finding specials...",
      textAlign: TextAlign.center,
    );
  }

  Widget listOfSpecies() {
    return ListView.builder(
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (BuildContext context, int index) {
        return speciesListItem(index);
      },
    );
  }

  Container speciesListItem(int index) {
    var language = data[index]['language'];
    var name = data[index]['name'];
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Image.asset(
          'images/paladin.png',
          height: 100.0,
          width: 100.0,
        ),
        Card(
            child: ExpansionTile(
          title: Text(
            name,
            textAlign: TextAlign.center,
          ),
          children: <Widget>[
            Container(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'images/boo_actual_character.png',
                  height: 80.0,
                  width: 80.0,
                  alignment: Alignment.centerRight,
                )),
            ListTile(
                title: Text(
              "Language: $language",
              textAlign: TextAlign.center,
            )),
            //Text(data[index]['language']),
          ],
        ))
      ],
    ));
  }
}
