import 'package:flutter/material.dart';

class Session extends ChangeNotifier {
  static Session _instance = Session._internal();
  bool showLayoutSelector = false;
  bool showLayoutFlexSelector = false;
  int currentPage = 0;
  factory Session() {
    return _instance;
  }
  notify() {
    print('NOTIFY');
    notifyListeners();
  }

  Session._internal();
}
