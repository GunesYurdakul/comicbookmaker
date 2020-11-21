import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'dynamic-layout-item.dart';

class DynamicLayout extends StatefulWidget {
  final int pageNumber;

  DynamicLayout({Key key, this.pageNumber}) : super(key: key);
  @override
  _DynamicLayoutState createState() => _DynamicLayoutState();
}

class _DynamicLayoutState extends State<DynamicLayout> {
  int numRows;
  int numCols;
  List<int> flexValues;
  @override
  void initState() {
    numRows = 3;
    numCols = 4;
    flexValues = List<int>.filled(numRows * numCols, 1);
    print('INIT LAYOUT');
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:false,
        body: Stack(children: [
      Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 3)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
                numCols,
                (indexRow) => Expanded(
                    flex: flexValues[indexRow],
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                            numRows,
                            (indexCol) => Expanded(
                                flex: flexValues[indexCol],
                                child: Container(
                                  child: DynamicLayoutItem(),
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.black, width: 3)),
                                  width: ((MediaQuery.of(context).size.width -
                                              5 * (numCols * 2 + 2)) /
                                          numCols)
                                      .floor()
                                      .toDouble(),
                                  height: (((MediaQuery.of(context).size.width /
                                                      210) *
                                                  297 -
                                              5 * (numRows * 2 + 2)) /
                                          numRows)
                                      .floor()
                                      .toDouble(),
                                )))))),
          )),
      Positioned(
          right: 0,
          bottom: 0,
          child: Container(
              width: 30,
              height: 30,
              child: Center(
                  child: Text(
                (widget.pageNumber + 1).toString(),
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'AdemWarren',
                    fontSize: 20),
              )),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 3),
                  shape: BoxShape.rectangle,
                  color: Colors.white)))
    ]));
  }
}
