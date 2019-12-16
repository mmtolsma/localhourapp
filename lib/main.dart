import 'package:flutter/material.dart';
import 'app_screens/secondpage.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(
      title: "Local Hour application",
      debugShowCheckedModeBanner: false,
      home: MyTabs(),
    ));

class MyTabs extends StatefulWidget {
  @override
  MyTabsState createState() => MyTabsState();
}

class MyTabsState extends State<MyTabs> with SingleTickerProviderStateMixin {
  final String url = 'https://local.ponelat.com'; //API url
  List specials;
  TabController controller;

  List<Widget> myTabs = [
    Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text("Today", style: TextStyle(fontSize: 15.0)),
    ),
    Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text("Tomorrow", style: TextStyle(fontSize: 15.0)),
    ),
    Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text("Next Day", style: TextStyle(fontSize: 15.0)),
    ),
  ];

  @override
  void initState() {
    super.initState();

    controller = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<List> getSpecials() async {
    var response = await http.get(Uri.encodeFull(url + '/specials'),
        headers: {"Accept": "application/json"});
    return jsonDecode(response.body);
  }

  Map splitIntoDays(specials)
  {
    //daysOfWeekIndex[0] = Sunday

    var today = [];
    var tomorrow = [];
    var nextDay = [];

    var todayDate = DateTime.now();
    var todayIndex = todayDate.weekday;

    for(var i = 0; i < specials.length; i++) {

      var special = specials[i];

      if(special['dayOfWeekIndex'] == todayIndex) {
        today.add((special));
      }

      var tomorrowIndex = (todayIndex + 1) % 7;
      if(special['dayOfWeekIndex'] == tomorrowIndex) {
        tomorrow.add(special);
      }

      var nextDayIndex = (todayIndex + 2) % 7;
      if(special['dayOfWeekIndex'] == nextDayIndex) {
        nextDay.add(special);
      }
    }

    return {"today": today, "tomorrow": tomorrow, "nextDay": nextDay};
  }

  @override
  Widget build(BuildContext context) {
    print("Build");
    return FutureBuilder(
      future: getSpecials().then(splitIntoDays),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Finding Specials", style: TextStyle(color: Colors.white, fontSize: 15.0,
                decoration: TextDecoration.none)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: CircularProgressIndicator()
                ),
              ),
            ],
          );
        }
        return Scaffold(
          appBar: AppBar(
              leading: Icon(Icons.dehaze),
              //there's an "action" option for menus and stuff. "leading" for show
              title: Text("LOCAL HOUR"),
              backgroundColor: Colors.green,
              bottom: TabBar(
                controller: controller,
                tabs: myTabs.toList(),
              )),
          body: TabBarView(
            controller: controller,
            children: <Widget>[
              SecondPage(specials: snapshot.data["today"]),
              SecondPage(specials: snapshot.data["tomorrow"]), //Not sure if this is the right way to go about it
              SecondPage(specials: snapshot.data["nextDay"]),
            ],
          ),
        );
      },
    );
  }
}
