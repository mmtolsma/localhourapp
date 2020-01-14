import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:localhour/global-data.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

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
    final FirebaseUser user = authResult.user; //create new file, make a class, one of its fields is a Firebase User and you import it and assign it to this class. Singleton. ***Get user object into the tab file***

    globalData.user = user; //this accesses .uid / .displayName / .email / .photoUrl

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    print(globalData.user.uid);
    print(globalData.user.email);
    print(globalData.user.displayName);
    print(globalData.user.photoUrl);

    return true;
  } catch (error) {
    return false;
  }
}

void signOutGoogle(context) async{
  await googleSignIn.signOut();
  Navigator.pushNamed(context, '/login-page');
  print("User Sign Out");
}