import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class SpecialsListItem extends StatefulWidget {
  final String venue;
  final String dayOfWeek;
  final String specialTime;
  final String specialSummary;
  final String specialDetails;

  @override
  SpecialsListItem({this.venue,
    this.dayOfWeek,
    this.specialTime,
    this.specialSummary,
    this.specialDetails});

  SpecialsListItemState createState() => SpecialsListItemState(
          venue: venue,
          dayOfWeek: dayOfWeek,
          specialTime: specialTime,
          specialSummary: specialSummary,
          specialDetails: specialDetails);
}

class SpecialsListItemState extends State<SpecialsListItem> {
  bool isExpanded = false;
  String venue;
  String dayOfWeek;
  String specialTime;
  String specialSummary;
  String specialDetails;

  SpecialsListItemState({this.venue,
    this.dayOfWeek,
    this.specialTime,
    this.specialSummary,
    this.specialDetails});

  @override
  void initState() {
    super.initState();
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

    var rows = <Widget>[
      Padding(
        padding: const EdgeInsets.all(paddingSize),
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                MarkdownBody(
                  styleSheet: MarkdownStyleSheet(
                    textScaleFactor: 1.5,
                  ),
                  data: venue,
                )
//                Text(venue,
//                    style: TextStyle(fontSize: 20.0, color: Colors.black)
//                ),
              ],
            ),

            Spacer(flex: 1),

            Column(
              children: <Widget>[
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(paddingSize),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(3.0))
                    ),
                    child: Text(specialTime,
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
            MarkdownBody(
              styleSheet: MarkdownStyleSheet(
                textScaleFactor: 1.5,
              ),
              data: specialSummary,
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
              expandIcon,
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: toggleExpand,
      child: Card(
        child: Container(
            padding: EdgeInsets.all(5.0),
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