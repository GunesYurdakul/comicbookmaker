import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../image/image-item.dart';

class DynamicLayoutItem extends StatefulWidget {
  DynamicLayoutItem({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _DynamicLayoutItemState createState() => _DynamicLayoutItemState();
}

class _DynamicLayoutItemState extends State<DynamicLayoutItem>
    with SingleTickerProviderStateMixin {
  CurvedAnimation curve;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
          children: [
            new ImageItem(),
            Center(
              child: IconButton(
                icon: Icon(
                  Icons.grid_on,       
                  size:40),
                onPressed: (){},
                color:Colors.white,
              )),
          ]
        );
  }
}
