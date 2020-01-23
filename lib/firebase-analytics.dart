import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:localhour/global-data.dart';

final FirebaseAnalytics analytics = new FirebaseAnalytics();
var fireBaseAnalyticsDataObject = new FireBaseAnalyticsData();

class FireBaseAnalyticsData {
  //Record login
  void onLogin(bool result) {
    if(result)
    {
      analytics.logLogin();

      analytics.setUserProperty(
        name: 'Username',
        value: globalData.user.displayName);

      analytics.setUserProperty(
        name: 'Email',
        value: globalData.user.email);
    }
    else
      print("Error delivering login stats");
  }

  //Record sign out
  void onSignOut(bool result) {
    if(result) {
      analytics.logEvent(
        name: 'Signed_out',
        parameters: {
          'User_name': globalData.user.displayName} //to do. Not sure how to pass the display name here.
        ); //globalData.user.displayName.toString()
        //Doesn't work when user is signed in from before
    }
    else
      print("Could not send sign out stats");
  }

  //Record tab change on swipe and tap
  void tabChanged(int prevIndex, int currentIndex, Future<List> specials) {
    specials.then((data) {
      if(currentIndex != prevIndex) {
        analytics.logEvent(
          name: "tab_changed",
          parameters: {
            'tab_name': data[currentIndex]['title'],
            'prev_tab_name': data[prevIndex]['title'],
          }
        );
      }
    });
  }

  void specialExpanded(String venue, String specialSummary, String dayOfWeek, bool isExpanded) {
    var tappedState = isExpanded == true ? "expanded" : "collapsed";

    analytics.logEvent(
        name: 'special_tapped',
        parameters: {
          'venue' : venue,
          'special_summary' : specialSummary,
          'day_of_week' : dayOfWeek,
          'expanded_state' : tappedState,
        }
    );
  }

}





