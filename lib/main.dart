import 'package:flutter/material.dart';
import 'app_screens/secondpage.dart';

void main() => runApp(MaterialApp(
      title: "SWAPI application",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: <String, WidgetBuilder> { //creating routes to new pages
        "/SecondPage": (BuildContext context) => new SecondPage() //link to second page
      }
    ));

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SWAPI species"), backgroundColor: Colors.green,), //creates strip at top of app
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.launch, color: Colors.redAccent,),
                iconSize: 100.0,
                onPressed: () {Navigator.of(context).pushNamed("/SecondPage");}
              ),
              Text("Find Species")
            ],
          )
        )
      )
    );
  }
}

//context: Describes the part of the user interface represented by this widget.