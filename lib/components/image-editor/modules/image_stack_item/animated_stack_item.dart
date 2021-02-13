import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math';

import 'edit_text.dart';

class AnimatedStackItem extends StatefulWidget {
  final double left;
  final double top;
  final double fontsize;
  final double width;
  final String imagePath;
  final bool hasText;
  final VoidCallback onMoving;
  final VoidCallback onDelete;
  final Function(AnimatedStackItemState) onStopMoving;
  final Function(Map<String, dynamic>) saveState;
  final AnimatedStackItemState state;
  final bool showButtons;
  AnimatedStackItem(
      {Key key,
      this.left,
      this.top,
      this.fontsize,
      this.imagePath,
      this.onMoving,
      this.hasText,
      this.onStopMoving,
      this.onDelete,
      this.state,
      this.saveState,
      this.width,
      this.showButtons})
      : super(key: key);
  @override
  AnimatedStackItemState createState() => AnimatedStackItemState();
}

class AnimatedStackItemState extends State<AnimatedStackItem> {
  double _baseScaleFactor = 1;
  double scaleFactor = 1;
  double width;
  double _fontSize = 15;
  Color _textColor = Colors.black;
  String text = 'Text';
  Offset lastPosition;
  bool _isEditingText = false;
  bool moving = false;
  var rotation = 0.0;
  Offset offset = Offset(0, 0);
  Offset position = Offset(0, 0);
  TextEditingController _editingController;
  final _focusNodeName = FocusNode();

  @override
  void initState() {
    if (widget.state != null) {
      position = widget.state.position;
      lastPosition = widget.state.lastPosition;
      offset = widget.state.offset;
      scaleFactor = widget.state.scaleFactor;
      rotation = widget.state.rotation;
    }
    if (widget.width != null)
      width = widget.width;
    else
      width = 200;
    _editingController = TextEditingController(text: text);
    super.initState();
  }

  @override
  void dispose() {
    widget.saveState({
      'position': position,
      'lastPosition': lastPosition,
      'offset': offset,
      'width': width,
      'scaleFactor': scaleFactor,
      'rotation': rotation,
    });
    _editingController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AnimatedStackItem oldWidget) {
    // TODO: implement didUpdateWidget
    setState(() {
      print(widget.showButtons.toString() + 'jdkfl');
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: position.dx,
        top: position.dy,
        child: Stack(
          alignment: Alignment.center, 
          children: <Widget>[
          GestureDetector(
              child: Transform.rotate(
                  angle: (pi / 180) * rotation,
                  child: Container(
                      decoration: BoxDecoration(),
                      child: Image(
                        image: AssetImage(widget.imagePath),
                        width: width * scaleFactor,
                      ))),
              onScaleStart: (details) {
                _baseScaleFactor = scaleFactor;
                lastPosition = details.localFocalPoint;
              },
              onScaleUpdate: (details) {
                widget.onMoving();
                setState(() {
                  moving = true;
                  print(rotation);
                  scaleFactor = _baseScaleFactor * details.scale;
                  offset -= (lastPosition - details.localFocalPoint);
                  position = offset;
                  rotation += details.rotation;
                  lastPosition = details.localFocalPoint;
                });
                if (offset.dy < 5 && offset.dx < (MediaQuery.of(context).size.width / 4) + 30 && offset.dx > (MediaQuery.of(context).size.width / 4) - 30) {
                  scaleFactor /= 3;
                }
              },
              onScaleEnd: (endDetails) {
                print(offset);
                if (offset.dy < 15 && offset.dx < (MediaQuery.of(context).size.width / 4) + 30 && offset.dx > (MediaQuery.of(context).size.width / 4) - 30) {
                  widget.onDelete();
                }
                widget.onStopMoving(widget.state);
                setState(() {
                });
              },
              onTap: () {}),
          getTextBox(),
          widget.showButtons ? Positioned(right: 0, top: 0, child: getLayerSettings()) : Container(),
          widget.showButtons
              ? Positioned(
                  left: 0,
                  top: 0,
                  child: IconButton(
                    icon: Icon(Icons.rotate_90_degrees_ccw_sharp),
                    onPressed: () {
                      setState(() {
                        rotation += 30;
                      });
                    },
                  ))
              : Container(),
        ]));
  }

  Widget getTextBox() {
    return widget.hasText != null ? 
      Container(
        width: width * scaleFactor / 2, 
        child: EditText(scaleFactor: scaleFactor)
      ) : Container();
  }

  Widget getLayerSettings() {
    return DropdownButton(
        items: [
          DropdownMenuItem(value: 1, child: Text('1')),
          DropdownMenuItem(value: 2, child: Text('1')),
          DropdownMenuItem(value: 3, child: Text('1')),
        ],
        value: 1,
        onChanged: (val) {},
        icon: IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {},
        ));
  }
}
