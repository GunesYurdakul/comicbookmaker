import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './components/homepage/homepage.dart';
import 'package:custom_splash/custom_splash.dart';

void main() {
  runApp(new MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Color(0xffE20025)),
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Color(0xff0060AA)),
        fontFamily: 'AdemWarren',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CustomSplash(
      imagePath: 'assets/comicsy_logo.png',
      backGroundColor: Colors.white,
      animationEffect: 'zoom-in',
      logoSize: 400,
      home: MyHomePage(),
      // customFunction: duringSplash,
      duration: 2500,
      type: CustomSplashType.StaticDuration,
    );
  }
}
