import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:projectX/components/dynamic-layout/dynamic-layout-item.dart';

class DynamicLayout extends StatefulWidget {
  final int pageNumber;
  final StaggeredGridView grid;

  DynamicLayout({Key key, this.pageNumber, this.grid}) : super(key: key);
  @override
  _DynamicLayoutState createState() => _DynamicLayoutState();
}

class _DynamicLayoutState extends State<DynamicLayout> {
  StaggeredGridView grid;
  @override
  void initState() {
    print('INIT LAYOUT');
    grid = widget.grid;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('layout rebuild');
    return Scaffold(
        bottomNavigationBar: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width / 40),
                  child: Text(widget.pageNumber.toString(),
                      style: TextStyle(fontFamily: 'AdemWarren')))
            ]),
        body: widget.grid);
  }
}
