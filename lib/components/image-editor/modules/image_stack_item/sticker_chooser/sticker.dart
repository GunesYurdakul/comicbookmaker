import 'package:flutter/material.dart';
import 'dart:math';

import 'package:projectX/components/image-editor/modules/image_stack_item/animated_stack_item.dart';
import '../animated_stack_item.dart';

class StickerView extends StatefulWidget {
  final String value;
  final VoidCallback onMoving;
  final Function(AnimatedStackItemState) onStopMoving;
  final VoidCallback onDelete;
  final AnimatedStackItemState state = AnimatedStackItemState();

  StickerView(
      {Key key, this.value, this.onMoving, this.onStopMoving, this.onDelete})
      : super(key: key);
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
        state:widget.state,
        imagePath: widget.value,
        onMoving: () => {widget.onMoving()},
        onStopMoving: (state) => {widget.onStopMoving(state)},
        onDelete: () => {widget.onDelete()},
        saveState: (stateBeforeDispose)=> saveWidgetState(stateBeforeDispose)
    );
  }

  saveWidgetState(stateBeforeDispose){
    widget.state.position=stateBeforeDispose['position'];
    widget.state.lastPosition=stateBeforeDispose['lastPosition'];
    widget.state.offset=stateBeforeDispose['offset'];
    widget.state.width=stateBeforeDispose['width'];
    widget.state.height=stateBeforeDispose['height'];
    widget.state.scaleFactor=stateBeforeDispose['scaleFactor'];
    widget.state.rotation=stateBeforeDispose['rotation'];
  }
}
