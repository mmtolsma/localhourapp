import 'package:flutter/material.dart';
import 'package:localhour/components/OptionsMenu.dart';
import 'app_screens/specials-list.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

const Color COLORS_BG = Colors.white;
const Color COLORS_0 = Colors.redAccent;
const Color COLORS_1 = Colors.yellow;
const Color COLORS_2 = Colors.orangeAccent;

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
  TabController controller;
  int tabIndex = 0;
  Future<List> specials;

  List<Widget> myTabs(List views) {
    return [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: FittedBox(
              child: Text(views[0]['title'], style: TextStyle(color: Colors.black))
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: FittedBox(
              child: Text(views[1]['title'], style: TextStyle(color: Colors.black))
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: FittedBox(
              child: Text(views[2]['title'], style: TextStyle(color: Colors.black))
          ),
        ),
      ];
  }

  @override
  void initState() {
    super.initState();
    specials = getSpecials();
    controller = TabController(vsync: this, length: 3);
    controller.addListener(updateTabColorFromControllerIndex);
  }

  updateTabColorFromControllerIndex() {
    setState(() {
      tabIndex = controller.index;
    });
  }

  @override
  void dispose() {
    controller.removeListener(updateTabColorFromControllerIndex);
    controller.dispose();
    super.dispose();
  }

  Future<List> getSpecials() async {
    var response = await http.get(Uri.encodeFull(url + '/specials-views'),
        headers: {"Accept": "application/json"});
    var jsonData = jsonDecode(response.body);
    return jsonData;
  }

  Future<List> getSpecialsForIndex(int index) {
    var f = getSpecials();
    setState(() {
      specials = f;
    });
    return f.then((data) => data[index]["specials"]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: specials,
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
              backgroundColor: COLORS_BG,
              title: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                    children: <Widget>[
                    Image.asset('images/localhourlogo.png', fit: BoxFit.contain, height: 60.0),
                    ]),
              ),
              actions: <Widget>[
                PopupMenuButton<String>(
                  icon: Icon(Icons.settings, color: Colors.black),
                  onSelected: choiceAction,
                  itemBuilder: (BuildContext context) {
                    return MenuItems.choices.map((String choice) {
                      return PopupMenuItem<String> (
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                )
              ],
              bottom: TabBar(
                  controller: controller,
                  tabs: myTabs(snapshot.data),
                  indicator: BoxDecoration(color: colorForTab(tabIndex)),
                  onTap: (index) {
                    setState(() {
                      tabIndex = index;
                    });
                  }
              )
          ),
          body: TabBarView(
            controller: controller,
            children: <Widget>[
              Scaffold(
                  appBar: AppBar(
                    backgroundColor: colorForTab(tabIndex),
                    centerTitle: true,
                    title: Text(snapshot.data[0]['heading'], style: TextStyle(color: Colors.black),)),
                  body: SpecialsList(
                    specials: snapshot.data[0]['specials'],
                    specialsIndex: 0,
                    refresh: getSpecialsForIndex,
                  )),
              Scaffold(
                  appBar: AppBar(
                    backgroundColor: colorForTab(tabIndex),
                    centerTitle: true,
                    title: Text(snapshot.data[1]['heading'], style: TextStyle(color: Colors.black),)),
                  body: SpecialsList(
                    specials: snapshot.data[1]['specials'],
                    specialsIndex: 1,
                    refresh: getSpecialsForIndex,
                  ),

              ),
              Scaffold(
                  appBar: AppBar(
                      backgroundColor: colorForTab(tabIndex),
                      centerTitle: true,
                      title: Text(snapshot.data[2]['heading'], style: TextStyle(color: Colors.black),)),
                  body: SpecialsList(
                    specials: snapshot.data[2]['specials'],
                    specialsIndex: 2,
                    refresh: getSpecialsForIndex,)),
            ],
          ),
        );
      }
      );
    }

  void choiceAction(String choice) {
    if(choice == MenuItems.Settings) {
      print('Settings');
    }
    else if(choice == MenuItems.SignIn) {
      print('Sign In');
    }
    else if(choice == MenuItems.SignOut) {
      print('Sign Out');
    }
  }
}

Color colorForTab(int tabIndex){
  if(tabIndex == 0){
    return COLORS_0;
  }else if(tabIndex == 1){
    return COLORS_1;
  }else if(tabIndex == 2){
    return COLORS_2;
  }
  return COLORS_0;
}
