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
          appBarTheme: AppBarTheme(color: Colors.blue[100]),
          floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.pink[100]),
          primarySwatch: Colors.pink,
          iconTheme: IconThemeData(color: Colors.grey[600]),
          visualDensity: VisualDensity.adaptivePlatformDensity,
    ));
  }
}
