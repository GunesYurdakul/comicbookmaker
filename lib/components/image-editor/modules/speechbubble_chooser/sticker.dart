import 'package:flutter/material.dart';
import 'dart:math';

class SpeechBubbleView extends StatefulWidget {
  final double left;
  final double top;
  final Function(ScaleStartDetails) onScaleStart;
  final Function(ScaleUpdateDetails) onScaleUpdate;
  final double fontsize;
  final String value;
  const SpeechBubbleView(
      {Key key,
      this.left,
      this.top,
      this.onScaleStart,
      this.onScaleUpdate,
      this.fontsize,
      this.value})
      : super(key: key);
  @override
  _SpeechBubbleViewState createState() => _SpeechBubbleViewState();
}

class _SpeechBubbleViewState extends State<SpeechBubbleView> {
  double _baseScaleFactor = 1;
  double _scaleFactor = 1;
  double width = 100;
  double height = 100;
  Offset lastPosition;
  var lastRotation = 0.0;
  var rotation = 0.0;
  Offset offset = Offset(0, 0);
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
