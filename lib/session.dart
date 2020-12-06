import 'package:flutter/material.dart';

import 'db/database_helper.dart';

class Session extends ChangeNotifier {
  final dbHelper = DatabaseHelper.instance;
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
  initDatabase()async{
    await _instance.dbHelper.database;
  }
  void _insert() async {
    // row to insert
    Map<String, dynamic> row = {};
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }

  void _update() async {
    // row to update
    Map<String, dynamic> row = {};
    final rowsAffected = await dbHelper.update(row);
    print('updated $rowsAffected row(s)');
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }

  Session._internal();
}
