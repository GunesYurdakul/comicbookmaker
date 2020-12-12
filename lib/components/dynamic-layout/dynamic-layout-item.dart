import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../image/image-item.dart';

class DynamicLayoutItem extends StatefulWidget {
  final double height;
  final double width;
  DynamicLayoutItem({Key key, this.title, this.height, this.width}) : super(key: key);

  final String title;
  @override
  _DynamicLayoutItemState createState() => _DynamicLayoutItemState();
}

class _DynamicLayoutItemState extends State<DynamicLayoutItem> with SingleTickerProviderStateMixin {
  CurvedAnimation curve;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Center(
          child: ImageItem(
        width: widget.width,
        height: widget.height,
      )),
    ]);
  }
}
