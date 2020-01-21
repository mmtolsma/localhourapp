import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localhour/app_screens/tab-creation.dart';
import 'package:localhour/components/sign-in.dart';
import 'package:localhour/firebase-analytics.dart';
import 'dart:io';

import 'package:localhour/global-data.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  noInternetAlertDialog(BuildContext context) {
    return showDialog(context: context, builder: (context){
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pop(true);
      });
      return AlertDialog(
        title: Text("Connection problem!", textAlign: TextAlign.center,),
        content: Text("No internet connection detected!", textAlign: TextAlign.center,),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage("images/localhourlogo.png"), height: 80.0),
              SizedBox(height: 50),
              _signInButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () async {
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            print('connected');
            bool result = await signInWithGoogle();
            if (result) {
//              Navigator.pushNamed(context, '/specials-page',
//                  arguments: MyTabs(
//                    userDisplayName: globalData.user.displayName.toString(),
//                    userEmail: globalData.user.email.toString(),
//                    userPhotoUrl: globalData.user.photoUrl.toString(),
//                  )
//              ); //This doesn't work. Think applying arguments to routenames is a bit more challenging
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyTabs(
                    userPhotoUrl: globalData.user.photoUrl.toString(),
                    userEmail: globalData.user.email.toString(),
                    userDisplayName: globalData.user.displayName.toString(),
                  )
                ),
              );
              fireBaseAnalyticsDataObject.onLogin(result);
            }
            else
              print("error logging in");
          }
        } on SocketException catch (_) {
          noInternetAlertDialog(context);
          print('not connected');
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("images/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}