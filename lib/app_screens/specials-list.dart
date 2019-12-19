import 'package:flutter/material.dart';
import 'package:localhour/components/specials-list-item.dart';

class SpecialsList extends StatefulWidget {
  final List specials;
  final Function refresh;
  final int specialsIndex;

  SpecialsList({this.specials, this.refresh, this.specialsIndex});

  @override
  SpecialsListState createState() => SpecialsListState(
      specials: specials, refresh: refresh, specialsIndex: specialsIndex);
}

class SpecialsListState extends State<SpecialsList> {
  List specials;
  Function refresh;
  int specialsIndex;

  SpecialsListState({this.specials, this.refresh, this.specialsIndex});

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
    Future f = refresh(specialsIndex);
    f.then((newSpecials) {
      setState(() {
        specials = newSpecials;
      });
    });
    await f;
    return null;
  }

  Widget listOfSpecies() {
    return specials.isEmpty
        ? RefreshIndicator(
            onRefresh: refreshList,
            child: Center(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  alignment: Alignment.center,
                  height: 400.0, //BAD! Need a way to fix this height issue!
                  width: MediaQuery.of(context).size.width,
                  child: Text('No specials here!', style: TextStyle(fontSize: 30.0),),
                ),
              ),
            ),
          )
        : RefreshIndicator(
            child: ListView.builder(
              itemCount: specials == null ? 0 : specials.length,
              itemBuilder: (BuildContext context, int index) {
                return speciesListItem(index);
              },
            ),
            onRefresh: refreshList,
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
