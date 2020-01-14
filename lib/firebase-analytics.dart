import 'package:firebase_analytics/firebase_analytics.dart';

final FirebaseAnalytics analytics = FirebaseAnalytics();

class FireBaseAnalyticsData {

  void onLogin(bool result) {
    if(result)
    {
      analytics.logLogin();
      print("Log in successful");
    }
    else
      print("Error delivering login stats");
  }
}

