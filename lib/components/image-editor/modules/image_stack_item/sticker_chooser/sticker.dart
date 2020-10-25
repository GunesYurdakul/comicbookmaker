import 'package:flutter/material.dart';
import 'dart:math';

import 'package:projectX/components/image-editor/modules/image_stack_item/animated_stack_item.dart';
import '../animated_stack_item.dart';

class StickerView extends StatefulWidget {
  final String value;
  final VoidCallback onMoving;
  StickerView({Key key, this.value, this.onMoving}) : super(key: key);
  @override
  _StickerViewState createState() => _StickerViewState();
}

class _StickerViewState extends State<StickerView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedStackItem(
                          imagePath: widget.value,
                          onMoving: ()=> {widget.onMoving()},);
  }
}
