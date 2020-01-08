import 'package:flutter/material.dart';
import 'package:localhour/app_screens/tab-creation.dart';
import 'app_screens/login-page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/login-page': (context) => LoginPage(),
        '/specials' : (context) => MyTabs(),
        },
      debugShowCheckedModeBanner: false,
      title: 'localhour',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}