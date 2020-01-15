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

  //Record sign out
  void onSignOut(bool result) {
    if(result) {
      analytics.logEvent(
          name: 'Signed_out',
          parameters: {'User_name': globalData.user.displayName});
    }
    else
      print("Could not send sign out stats");
  }

  //Record tab change on swipe and tap
  void tabChanged(int tabIndex, int index) {

    String tabTitle;

    switch(index) { //This is not ideal, but I don't know how to pass in the title data dynamically
      case 0:
        tabTitle = "Today";
        break;
      case 1:
        tabTitle = "Tomorrow";
        break;
      case 2:
        tabTitle = "Next_day"; //Can't have spaces for FireBase events
        break;
      default:
        tabTitle = "Error";
    }

    if(index != tabIndex) {
      analytics.logEvent(
          name: "$tabTitle" + "_Tab_View",
          parameters: {'Tab_Name': tabTitle}
      );
    }
  }
}





