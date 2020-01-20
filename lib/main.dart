import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:localhour/app_screens/tab-creation.dart';
import 'app_screens/login-page.dart';
import 'package:localhour/firebase-analytics.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login-page',
      routes: {
        '/login-page': (context) => LoginPage(),
        '/specials-page' : (context) => MyTabs(),
        },
      debugShowCheckedModeBanner: false,
      title: 'localhour',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: LoginPage(), //Warning: When using initialRoute, don’t define a home property.
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }
}