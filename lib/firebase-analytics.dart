import 'package:firebase_analytics/firebase_analytics.dart';

final FirebaseAnalytics analytics = FirebaseAnalytics();

class FireBaseAnalyticsData {

  void onLogin(var result) {
    if(result == "Succeed")
    {
      analytics.logLogin();
      print("Log in successful");
    }
    else
      print("Error delivering login stats");
  }

}

