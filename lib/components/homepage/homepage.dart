import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projectX/components/comicbook-library/comicbook_library.dart';
import 'package:projectX/session.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
     
    return FutureBuilder<dynamic>(
        future: Session().initDatabase(), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return ComicBookLibrary();
        });
  }
}
