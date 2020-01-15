import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localhour/components/options-menu.dart';
import 'package:localhour/app_screens/specials-list.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localhour/components/sign-in.dart';
import 'package:localhour/global-data.dart';
import 'package:localhour/firebase-analytics.dart';

const Color COLORS_BG = Colors.white;
const Color COLORS_0 = Colors.greenAccent;
const Color COLORS_1 = Colors.yellow;
const Color COLORS_2 = Colors.orangeAccent;

class MyTabs extends StatefulWidget {
  @override
  MyTabsState createState() => MyTabsState();
}

class MyTabsState extends State<MyTabs> with SingleTickerProviderStateMixin {
  final String url = 'https://local.ponelat.com'; //API url
  final String googleUserUrl = globalData.user.photoUrl;
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
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    specials = getSpecials();
    controller = TabController(vsync: this, length: 3, initialIndex: tabIndex);
    controller.addListener(updateTabColorFromControllerIndex);
    //listener called twice on tap, once on swipe (reason below)
    //https://github.com/flutter/flutter/issues/13848#issuecomment-354887932
  }

  updateTabColorFromControllerIndex() {
    setState(() {
      fireBaseAnalyticsDataObject.tabChanged(tabIndex, controller.index); //tracking of tab changes
      //How do I pass the title text (today, tom, next) from specials data?
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
              automaticallyImplyLeading: false,
                backgroundColor: COLORS_BG,
                title: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                      children: <Widget>[
                        Image.asset('images/localhourlogo.png', height: 60.0,),
                      ]),
                ),
                actions: <Widget>[
                  Container(
                    width: 60.0,
                    child: PopupMenuButton<String>(
                      icon: ClipOval(
                        child: Align(
                          heightFactor: 1,
                          widthFactor: 1,
                          child: Image.network(googleUserUrl),
                        ),
                      ),
                      onSelected: choiceAction,
                      itemBuilder: (BuildContext context) {
                        return MenuItems.choices.map((String choice) {
                          return PopupMenuItem<String> (
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                  )
                ],
                bottom: TabBar(
                    controller: controller,
                    tabs: myTabs(snapshot.data),
                    indicator: BoxDecoration(color: colorForTab(tabIndex)),
//                    onTap: (index) { //This section does fuck-all for the app?? Comment out and see.
//                      setState(() {
//                        fireBaseAnalyticsDataObject.tabChanged(
//                            tabIndex, index, snapshot.data[index]['title']); //tab tracking
//                        tabIndex = index;
//                      }
//                      );
//                    }
                )
            ),
            body: TabBarView(
              controller: controller,
              children: <Widget>[
                Scaffold(
                    appBar: AppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: colorForTab(tabIndex),
                        centerTitle: true,
                        title: Text(snapshot.data[0]['heading'], style: TextStyle(color: Colors.black),)),
                    body: SpecialsList(
                      specials: snapshot.data[0]['specials'],
                      specialsIndex: 0,
                      refresh: getSpecialsForIndex,
                    ),
                ),
                Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
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
                        automaticallyImplyLeading: false,
                        backgroundColor: colorForTab(tabIndex),
                        centerTitle: true,
                        title: Text(snapshot.data[2]['heading'], style: TextStyle(color: Colors.black),)),
                    body: SpecialsList(
                      specials: snapshot.data[2]['specials'],
                      specialsIndex: 2,
                      refresh: getSpecialsForIndex,)
                ),
              ],
            ),
          );
        }
    );
  }

  void choiceAction(String choice) {
    if(choice == MenuItems.SignOut) {
      bool result = true;
      signOutGoogle(context, result);
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