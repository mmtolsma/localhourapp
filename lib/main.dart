import 'package:flutter/material.dart';
import 'app_screens/specials-list.dart';
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

  List<Widget> myTabs(List views) {
    return [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(views[0]['title'], style: TextStyle(fontSize: 15.0)),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(views[1]['title'], style: TextStyle(fontSize: 15.0)),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(views[2]['title'], style: TextStyle(fontSize: 15.0)),
        ),
      ];
  }

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
    var response = await http.get(Uri.encodeFull(url + '/specials-views'),
        headers: {"Accept": "application/json"});
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSpecials(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Finding Specials",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        decoration: TextDecoration.none)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          );
        }
        return Scaffold(
          appBar: AppBar(
              leading: Icon(Icons.dehaze),
              title: Text("LOCAL HOUR"),
              bottom: TabBar(
                controller: controller,
                tabs: myTabs(snapshot.data),
                indicator: BoxDecoration(color: Colors.green),
              )
          ),
          body: TabBarView(
            controller: controller,
            children: <Widget>[
              Scaffold(
                  appBar: AppBar(
                      backgroundColor: Colors.green,
                      centerTitle: true,
                      title: Text(snapshot.data[0]['heading'])),
                  body: SpecialsList(specials: snapshot.data[0]['specials'])),
              Scaffold(
                  appBar: AppBar(
                      backgroundColor: Colors.purple,
                      centerTitle: true,
                      title: Text(snapshot.data[1]['heading'])),
                  body: SpecialsList(specials: snapshot.data[1]['specials'])),
              Scaffold(
                  appBar: AppBar(
                      backgroundColor: Colors.orange,
                      centerTitle: true,
                      title: Text(snapshot.data[2]['heading'])),
                  body: SpecialsList(specials: snapshot.data[2]['specials'])),
            ],
          ),
        );
      },
    );
  }
}
