import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './components/homepage/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: MyHomePage(),
        theme: ThemeData(
          appBarTheme: AppBarTheme(color: Color(0xffE20025)),
          floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Color(0xff0060AA)),
          fontFamily: 'AdemWarren',
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
    ));
  }
}
