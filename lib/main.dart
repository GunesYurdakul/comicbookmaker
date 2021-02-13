import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './components/homepage/homepage.dart';
import 'dart:io' show Platform;

void main() {
  String appId;
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    appId = "ca-app-pub-7789092779128108~6438931982";
  } else if (Platform.isIOS) {
    appId = "ca-app-pub-7789092779128108~5831770780";
  }
  FirebaseAdMob.instance.initialize(appId: appId);
  RewardedVideoAd.instance.listener =
      (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
    print("RewardedVideoAd event $event");
    if (event == RewardedVideoAdEvent.loaded) {
      RewardedVideoAd.instance.show().catchError((e) => print('Error in loading.2'));
    }
  };

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: MyHomePage(),
        theme: ThemeData(
          appBarTheme: AppBarTheme(color: Colors.blue[100]),
          floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.pink[100]),
          primarySwatch: Colors.pink,
          iconTheme: IconThemeData(color: Colors.grey[600]),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ));
  }
}
