import 'package:flutter/material.dart';

class ExpandableListItem extends StatefulWidget {
  String summary;

  @override
  ExpandableListItem({this.summary});

  ExpandableListItemState createState() => ExpandableListItemState(summary: summary);

}

class ExpandableListItemState extends State<ExpandableListItem> {
  bool isExpanded = false;
  String summary;

  ExpandableListItemState({this.summary});

  @override
  void initState() {
    //initial state of this widget i.e. initialisation of the widget
    super.initState(); //super is used to call the constructor of the BASE/PARENT class
  }

  toggleExpand() {
    setState(() {
        isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    var language = isExpanded ? "Expanded" : "Not Expanded";
    var _height = isExpanded ? 200.0 : 100.0;

    return Container(
      child: GestureDetector(
          onTap: toggleExpand,
          child: Container(
              height: _height,
              width: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: Column(children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(summary,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 20.0, color: Colors.black)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(language,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 20.0, color: Colors.green)),
                  ],
                )
              ]))),
    );
  }

}
