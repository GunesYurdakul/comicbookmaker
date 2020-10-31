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
    return new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: InkWell(child: new ImageItem()));
  }
}
