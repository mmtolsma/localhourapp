import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:localhour/global-data.dart';
import 'package:localhour/app_screens/tab-creation.dart';

import '../firebase-analytics.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = new GoogleSignIn();
final MyTabsState tabPageObject = new MyTabsState();

Future<bool> signInWithGoogle() async {
  try{
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    MyTabs(
      userDisplayName: user.displayName,
      userPhotoUrl: user.photoUrl,
      userEmail: user.email,
    );

    globalData.user = user; //this accesses .uid / .displayName / .email / .photoUrl

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return true;
  } catch (error) {
    return false;
  }
}

void signOutGoogle(context, result) async{
  await googleSignIn.signOut(); //Sign out the user
  await _auth.signOut(); //Sign out of authentication
  fireBaseAnalyticsDataObject.onSignOut(result);
  Navigator.of(context)
      .pushNamedAndRemoveUntil('/login-page', (Route<dynamic> route) => false);
  print("User Sign Out");

}