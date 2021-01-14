import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math';

class StickerImage extends StatefulWidget {
  final double left;
  final double top;
  final double fontsize;
  final double width;
  final File imageFile;
  final bool hasText;
  final VoidCallback onMoving;
  final VoidCallback onTap;
  final Function(StickerImageState) onStopMoving;
  final VoidCallback onDelete;
  final Function(Map<String, dynamic>) saveState;
  final StickerImageState state;
  StickerImage(
      {Key key,
      this.left,
      this.top,
      this.fontsize,
      this.imageFile,
      this.onMoving,
      this.hasText,
      this.onStopMoving,
      this.onDelete,
      this.state,
      this.saveState,
      this.width,
      this.onTap})
      : super(key: key);
  @override
  StickerImageState createState() => StickerImageState();
}

class StickerImageState extends State<StickerImage> {
  double _baseScaleFactor = 1;
  double scaleFactor = 1;
  double width;
  double _fontSize = 15;
  Color _textColor = Colors.black;
  String text = 'Text';
  Offset lastPosition;
  bool _isEditingText = false;
  TextEditingController _editingController;
  var rotation = 0.0;
  Offset offset = Offset(0, 0);
  Offset position = Offset(0, 0);
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
  Widget build(BuildContext context) {
    return Positioned(
        left: position.dx,
        top: position.dy,
        child: GestureDetector(
          child: Transform.rotate(
              angle: (pi / 180) * rotation,
              child: Stack(alignment: Alignment.center, children: <Widget>[
                Container(
                  child: Image.file(widget.imageFile),
                  width: width * scaleFactor,
                ),
              ])),
          onTap: () {
            widget?.onTap();
          },
          onScaleStart: (details) {
            _baseScaleFactor = scaleFactor;
            lastPosition = details.localFocalPoint;
          },
          onScaleUpdate: (details) {
            widget.onMoving();
            setState(() {
              print(rotation);
              scaleFactor = _baseScaleFactor * details.scale;
              offset -= (lastPosition - details.localFocalPoint);
              position = offset;
              rotation += details.rotation;
              lastPosition = details.localFocalPoint;
            });
            print('dx' + offset.dx.toString());
            print('width' + (MediaQuery.of(context).size.width / 4).toString());
            if (offset.dy < 5 && offset.dx < (MediaQuery.of(context).size.width / 4) + 30 && offset.dx > (MediaQuery.of(context).size.width / 4) - 30) {
              scaleFactor /= 3;
            }
          },
          onScaleEnd: (endDetails) {
            print(offset);
            if (offset.dy < 15 && offset.dx < (MediaQuery.of(context).size.width / 4) + 50 && offset.dx > (MediaQuery.of(context).size.width / 4) - 50) {
              widget.onDelete();
            }
            print('stop moving **');
            widget.onStopMoving(widget.state);
          },
        ));
  }
}
