import 'package:flutter/material.dart';
import 'dart:math';
import 'package:screenshot/screenshot.dart';

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
  String text = 'Text';
  Offset lastPosition;
  bool _isEditingText = false;
  TextEditingController _editingController;
  var lastRotation = 0.0;
  var rotation = 0.0;
  Offset offset = Offset(0, 0);

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: text);
  }

  @override
  void dispose() {
    _editingController.dispose();
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
              child: Stack(alignment: Alignment.center, children: <Widget>[
                Container(
                    child: Image(
                  image: AssetImage(widget.value),
                  width: width * _scaleFactor,
                  height: height * _scaleFactor,
                )),
                Container(
                  width: 40,
                  height: 20,
                  child: _editTitleTextField(),
                )
              ])),
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

  getTextInput() {
    print('getting text');
  }

  Widget _editTitleTextField() {
    if (_isEditingText)
      return Center(
        child: TextField(
          onSubmitted: (newValue) {
            setState(() {
              text = newValue;
              _isEditingText = false;
            });
          },
          autofocus: true,
          controller: _editingController,
        ),
      );
    return InkWell(
        onTap: () {
          setState(() {
            _isEditingText = true;
          });
        },
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
        ));
  }
}
