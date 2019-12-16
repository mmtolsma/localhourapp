import 'package:flutter/material.dart';
import 'package:swapi_project/components/expandable-list-item.dart';

class SecondPage extends StatefulWidget {

  final List specials;

  SecondPage({this.specials});

  @override
  SecondPageState createState() => SecondPageState(specials: specials);
}

class SecondPageState extends State<SecondPage> {

  List specials;
  SecondPageState({this.specials});

  @override
  Widget build(BuildContext context) {
    var secondPageBody;

    if (specials == null) {
      secondPageBody = loadingBar();
    } else {
      secondPageBody = listOfSpecies();
    }

    return Scaffold(
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
    return specials.isEmpty ? Center(child: Text("No specials today!", style: TextStyle(fontSize: 20.0),))
        : ListView.builder(
      itemCount: specials == null ? 0 : specials.length,
      itemBuilder: (BuildContext context, int index) {
          return speciesListItem(index);
      },
    );
  }

  Widget speciesListItem(int index) {
    return ExpandableListItem(
      venue: specials[index]['venue'],
      dayOfWeek: specials[index]['dayOfWeek'],
      specialTime: specials[index]['specialTime'],
      specialSummary: specials[index]['specialSummary'],
      specialDetails: specials[index]['specialDetails'],
    );
  }
}
