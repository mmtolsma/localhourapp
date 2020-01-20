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
            /// is because there is user already logged
            return MyTabs(
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