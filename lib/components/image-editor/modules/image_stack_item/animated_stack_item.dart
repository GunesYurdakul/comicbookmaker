import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedStackItem extends StatefulWidget {
  final double left;
  final double top;
  final double fontsize;
  final String value;
  final VoidCallback onMoving;
  final String imagePath;
  _AnimatedStackItemState state = _AnimatedStackItemState();
  AnimatedStackItem(
      {Key key, this.left, this.top, this.fontsize, this.value, this.onMoving, this.imagePath})
      : super(key: key);
  @override
  _AnimatedStackItemState createState() => _AnimatedStackItemState();
}

class _AnimatedStackItemState extends State<AnimatedStackItem> {
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
                image: AssetImage(widget.imagePath),
                width: width * _scaleFactor,
                height: height * _scaleFactor,
              )),
          onScaleStart: (details) {
            _baseScaleFactor = _scaleFactor;
            lastPosition = details.localFocalPoint;
          },
          onScaleUpdate: (details) {
            widget.onMoving();
            setState(() {
              _scaleFactor = _baseScaleFactor * details.scale;
              offset -= (lastPosition - details.localFocalPoint);
              if (offset.dy < 10 &&
                  (offset.dx < MediaQuery.of(context).size.width / 2.5 + 10 ||
                      offset.dx >
                          MediaQuery.of(context).size.width / 2.5 - 10)) {
                _scaleFactor /= 3;
                print('delete');
              }
              rotation += details.rotation;
              lastRotation = details.rotation;
              lastPosition = details.localFocalPoint;
            });
          },
        ));
  }
}
