import 'package:flutter/cupertino.dart';
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
  List<List<int>> flexColValues;
  List<int> flexRowValues;
  bool isLayoutChosen;

  @override
  void initState() {
    isLayoutChosen = false;
    setLayoutValues(1, 1);
    print('INIT LAYOUT');
    // TODO: implement initState
    super.initState();
  }

  setLayoutValues(_numRows, _numCols) {
    numRows = _numRows;
    numCols = _numCols;
    flexRowValues = List<int>.generate(numRows, (j) => 1);
    flexColValues = List<List<int>>.generate(
        numRows, (i) => List<int>.generate(numCols, (j) => 1));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
          isLayoutChosen
              ? getLayout()
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.black,
                  child: IconButton(
                      icon: Icon(
                        Icons.grid_on,
                        size: 34,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        layoutParameterSelector();
                      })),
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

  layoutParameterSelector() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Select Layout"),
              content: new Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                Row(children: [
                  Expanded(
                      child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Rows', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    initialValue: "1",
                    onChanged: (val) {
                        numRows = int.parse(val);
                    },
                  )),
                  SizedBox(width: 5),
                  Expanded(
                      child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Cols', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    initialValue: "1",
                    onChanged: (val) {
                        numCols = int.parse(val);
                    },
                  )),
                ])
              ]),
              actions: <Widget>[
                FlatButton(
                  child: Text('CREATE'),
                  onPressed: () {
                    setState(() {
                      isLayoutChosen = true;
                      setLayoutValues(numRows, numCols);  
                    });
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  Widget getLayout() {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 3)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(
              numRows,
              (indexRow) => Expanded(
                  flex: flexRowValues[indexRow],
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(
                          numCols,
                          (indexCol) => Expanded(
                              flex: flexColValues[indexRow][indexCol],
                              child: Container(
                                child: DynamicLayoutItem(),
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.black, width: 3)),
                                width: ((MediaQuery.of(context).size.width -
                                            5 * (numCols * 2 + 2)) *
                                        (flexColValues[indexRow][indexCol] /
                                            sum(flexColValues[indexRow]))) *
                                    flexColValues[indexRow][indexCol]
                                        .toDouble(),
                                height: (((MediaQuery.of(context).size.height -
                                            5 * (numRows * 2 + 2)) *
                                        (flexRowValues[indexRow] /
                                            sum(flexRowValues))))
                                    .toDouble(),
                              )))))),
        ));
  }

  int sum(List<int> l) {
    return l.reduce((a, b) => a + b);
  }
}
