import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ExpandableListItem extends StatefulWidget {
  final String venue;
  final String dayOfWeek;
  final String specialTime;
  final String specialSummary;
  final String specialDetails;

  @override
  ExpandableListItem({this.venue,
    this.dayOfWeek,
    this.specialTime,
    this.specialSummary,
    this.specialDetails});

  ExpandableListItemState createState() =>
      ExpandableListItemState(
          venue: venue,
          dayOfWeek: dayOfWeek,
          specialTime: specialTime,
          specialSummary: specialSummary,
          specialDetails: specialDetails);
}

class ExpandableListItemState extends State<ExpandableListItem> {
  bool isExpanded = false;
  String venue;
  String dayOfWeek;
  String specialTime;
  String specialSummary;
  String specialDetails;

  ExpandableListItemState({this.venue,
    this.dayOfWeek,
    this.specialTime,
    this.specialSummary,
    this.specialDetails});

  @override
  void initState() {
    //initial state of this widget i.e. initialisation of the widget
    super
        .initState(); //super is used to call the constructor of the BASE/PARENT class
  }

  toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    var expandIcon = isExpanded ? Icon(Icons.arrow_upward) :
    Icon(Icons.arrow_downward);
    const double paddingSize = 3.0;
    //Markdown(data: specialDetails); //handles markdown language i.e. **hello

    var rows = <Widget>[
      Padding(
        padding: const EdgeInsets.all(paddingSize),
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(venue,
                    style: TextStyle(fontSize: 20.0, color: Colors.black)
                ),
              ],
            ),

            Spacer(flex: 1), //adds the space between the column widgets!
            // flex = optional. Spacer places widgets far apart as possible
            //SizedBox(width: 100.0), Alternative for custom size

            Column(
              children: <Widget>[
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(paddingSize),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius:
                        new BorderRadius.all(new Radius.circular(3.0))
                    ),
                    child: Text(dayOfWeek,
                        style: TextStyle(fontSize: 20.0, color: Colors.white)
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      Padding(
        padding: const EdgeInsets.all(paddingSize),
        child: Row(
          children: <Widget>[
            Text(specialSummary,
                style: TextStyle(fontSize: 20.0, color: Colors.black)
            ),
          ],
        ),
      ),
    ];

    if (specialDetails == "") {
      rows.remove(expandIcon);
    }

    else if (isExpanded) {
      rows.add(
        Padding(
            padding: const EdgeInsets.all(paddingSize),
            child: Container(
              alignment: Alignment.centerLeft,
              child: MarkdownBody(
                styleSheet: MarkdownStyleSheet(
                  textScaleFactor: 1.5,
                ),
                data: specialDetails,
              ),
            )
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.start,
//            children: <Widget>[
//              Text(specialDetails,
//                  style: TextStyle(fontSize: 20.0),
//              ),
//            ],
//          ),
        ),
      );
      rows.add(expandIcon);
    }

    else {
      rows.add(
        Padding(
          padding: const EdgeInsets.all(paddingSize),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              expandIcon, //This is of type Icon(Icons.x)
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: toggleExpand,
      child: Card(
        child: Container(
            padding: EdgeInsets.all(5.0), //padding around each list item
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
            ),
            child: Column(
              children: rows,
            )
        ),
      ),
    );
  }
}