import 'package:flutter/material.dart';
import 'dart:math';

class StickerView extends StatefulWidget {
  final double left;
  final double top;
  final Function(ScaleStartDetails) onScaleStart;
  final Function(ScaleUpdateDetails) onScaleUpdate;
  final double fontsize;
  final String value;
  _StickerViewState state = _StickerViewState();
  StickerView(
      {Key key,
      this.left,
      this.top,
      this.onScaleStart,
      this.onScaleUpdate,
      this.fontsize,
      this.value})
      : super(key: key);
  @override
  _StickerViewState createState() => _StickerViewState();
}

class _StickerViewState extends State<StickerView> {
  double _baseScaleFactor = 1;
  double _scaleFactor = 1;
  double width = 100;
  double height = 100;
  Offset lastPosition;
  var lastRotation = 0.0;
  var rotation = 0.0;
  Offset offset = Offset(0, 0);

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      lastPosition = widget.state.lastPosition;
      offset = widget.state.offset;
      width = widget.state.width;
      rotation = widget.state.rotation;
      height = widget.state.height;
      _scaleFactor = widget.state._scaleFactor;
      rotation = widget.state.rotation;
    }
  }

  @override
  void dispose() {
    widget.state.lastPosition = lastPosition;
    widget.state.offset = offset;
    widget.state.width = width;
    widget.state.rotation = rotation;
    widget.state.height = height;
    widget.state._scaleFactor = _scaleFactor;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: offset.dx,
        top: offset.dy,
        child: GestureDetector(
          child: Transform.rotate(
              angle: (pi / 180) * rotation,
              child: Image(
                image: AssetImage(widget.value),
                width: width * _scaleFactor,
                height: height * _scaleFactor,
              )),
          onScaleStart: (details) {
            _baseScaleFactor = _scaleFactor;
            lastPosition = details.localFocalPoint;
          },
          onScaleUpdate: (details) {
            setState(() {
              print(rotation);
              _scaleFactor = _baseScaleFactor * details.scale;
              offset -= (lastPosition - details.localFocalPoint);
              rotation += details.rotation;
              lastRotation = details.rotation;
              lastPosition = details.localFocalPoint;
            });
          },
        ));
  }
}
