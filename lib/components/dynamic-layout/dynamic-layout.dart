import 'package:flutter/material.dart';
import 'package:projectX/components/dynamic-layout/dynamic-layout-item.dart';

class DynamicLayout extends StatefulWidget {
  @override
  _DynamicLayoutState createState() => _DynamicLayoutState();
}

class _DynamicLayoutState extends State<DynamicLayout> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[
        DynamicLayoutItem(),
        DynamicLayoutItem(),
        DynamicLayoutItem(),
        DynamicLayoutItem(),
        DynamicLayoutItem(),
        DynamicLayoutItem(),
      ],
    );
  }
}
