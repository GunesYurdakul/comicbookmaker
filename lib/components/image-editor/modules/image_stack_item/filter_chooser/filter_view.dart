import 'package:flutter/material.dart';

class FilterView extends StatefulWidget {
  @override
  _FilterViewState createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right:5,left:5),
      child: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.red,
      ),
    );
  }
}