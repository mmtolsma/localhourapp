import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:localhour/global-data.dart';

final FirebaseAnalytics analytics = FirebaseAnalytics();

class FireBaseAnalyticsData {

  void onLogin(bool result) {
    if(result)
    {
      analytics.logLogin();
      print("Log in successful");

      analytics.setUserProperty(name: 'Username', value: globalData.user.displayName);
      print("Username captured: " + globalData.user.displayName);

      analytics.setUserProperty(name: 'Email', value: globalData.user.email);
      print("Email captured: " + globalData.user.email);

      analytics.setUserProperty(name: 'PhotoUrl', value: globalData.user.photoUrl);
      print("Profile picture captured: " + globalData.user.photoUrl);
    }
    else
      print("Error delivering login stats");
  }
}

