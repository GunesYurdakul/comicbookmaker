import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DynamicLayout extends StatefulWidget {
  DynamicLayout({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DynamicLayoutState createState() => _DynamicLayoutState();
}

class _DynamicLayoutState extends State<DynamicLayout>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> animation;
  CurvedAnimation curve;
  int _numRows;
  int _numCols;
  final iconList = <IconData>[
    Icons.arrow_back,
    Icons.arrow_forward,
  ];

  @override
  void initState() {
    super.initState();
    _numCows = 1;
    _numCols = 1;
    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.5,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    Future.delayed(
      Duration(seconds: 1),
      () => _animationController.forward(),
    );
  }

  Widget _getInWidget() {
    if (_numRows > 1) {
      return Column(children: []);
    } else if (_numCols > 1) {
      return Row(children: []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(10),
        color: Colors.black,
        child: InkWell(
          onTap: askForSize(),
          child: _getInWidget(),
        ));
  }

  askForSize() {
    return; //show dialog to as for num of rows and cols
  }
}
