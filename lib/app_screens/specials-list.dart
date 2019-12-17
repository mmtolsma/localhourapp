import 'package:flutter/material.dart';
import 'package:swapi_project/components/specials-list-item.dart';

class SpecialsList extends StatefulWidget {
  final List specials;

  SpecialsList({this.specials});

  @override
  SpecialsListState createState() => SpecialsListState(specials: specials);
}

class SpecialsListState extends State<SpecialsList> {
  List specials;

  SpecialsListState({this.specials});

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

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      listOfSpecies();
      print("Done!");
    });

    return null;
  }

  Widget listOfSpecies() {
    return specials.isEmpty
        ? Center(
            child: Text("No specials today!",
            style: TextStyle(fontSize: 20.0),
          ))
        : Scaffold(
            body: RefreshIndicator(
              onRefresh: refreshList,
              child: ListView.builder(
                itemCount: specials == null ? 0 : specials.length,
                itemBuilder: (BuildContext context, int index) {
                  return speciesListItem(index);
                },
              ),
            ),
          );
  }

  Widget speciesListItem(int index) {
    return SpecialsListItem(
      venue: specials[index]['venue'],
      dayOfWeek: specials[index]['dayOfWeek'],
      specialTime: specials[index]['specialTime'],
      specialSummary: specials[index]['specialSummary'],
      specialDetails: specials[index]['specialDetails'],
    );
  }
}
