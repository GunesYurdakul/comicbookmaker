import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'dynamic-layout-item.dart';

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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('layout rebuild');
    return Scaffold(
        body: Stack(
          children: [
            //draw line methoduyla çizgiler çekecem ona göre bölecem
            DynamicLayoutItem(),
            /* new StaggeredGridView.countBuilder(
                key: new GlobalKey(),
                crossAxisCount: 4,
                itemCount: 8,
                itemBuilder: (BuildContext context, int index) =>
                    new DynamicLayoutItem(),
                staggeredTileBuilder: (int index) =>
                    new StaggeredTile.count(2, index.isEven ? 1 : 3),
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
            ), */  
            Positioned(
              right: 0,
              bottom: 0,
              child:Container(
                    width: 30,
                    height: 30,
                    child: Center(
                      child:Text((widget.pageNumber+1).toString(),
                      style: TextStyle(
                        color:Colors.black,
                        fontFamily: 'AdemWarren',
                        fontSize: 20),)),
                    decoration: BoxDecoration(
                      border: Border.all(color:Colors.black,width:3),
                        shape: BoxShape.rectangle,
                        color: Colors.white
                  )))
        ]
        ));
  }
}
