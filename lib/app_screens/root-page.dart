import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localhour/app_screens/login-page.dart';
import 'package:localhour/app_screens/tab-creation.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot){
          if (snapshot.hasData){
            print(snapshot.data.displayName);
            FirebaseUser user = snapshot.data; // this is your user instance
            return MyTabs( //passing parameters to MyTabs in order to load user data if previously signed in
              userDisplayName: user.displayName,
              userPhotoUrl: user.photoUrl,
              userEmail: user.email,
            );
          }
          else
            return LoginPage();
        }
    );
  }
}