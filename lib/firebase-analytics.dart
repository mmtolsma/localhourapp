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
      print("Log in successful");

      analytics.setUserProperty(name: 'Username', value: globalData.user.displayName);
      print("Username captured: " + globalData.user.displayName);

      analytics.setUserProperty(name: 'Email', value: globalData.user.email);
      print("Email captured: " + globalData.user.email);
    }
    else
      print("Error delivering login stats");
  }

//  //Record sign out
  void onSignOut(bool result) {
    if(result) {
      analytics.logEvent(
          name: 'Signed_out',
          parameters: {'User_name': "To_be_fixed"}); //globalData.user.displayName. Get's called on 'null'
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
            parameters: {'tab_name': data[currentIndex]['title'],
              'prev_tab_name': data[prevIndex]['title']}
        );
      }
    });

  }
}





