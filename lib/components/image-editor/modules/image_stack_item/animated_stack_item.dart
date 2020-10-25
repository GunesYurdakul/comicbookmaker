import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:screenshot/screenshot.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class AnimatedStackItem extends StatefulWidget {
  final double left;
  final double top;
  final double fontsize;
  final String imagePath;
  final bool hasText;
  final VoidCallback onMoving;
  final Function(AnimatedStackItemState) onStopMoving;
  final VoidCallback onDelete;
  final Function(Map<String, dynamic>) saveState;
  final AnimatedStackItemState state;
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
      this.saveState})
      : super(key: key);
  @override
  AnimatedStackItemState createState() => AnimatedStackItemState();
}

class AnimatedStackItemState extends State<AnimatedStackItem> {
  double _baseScaleFactor = 1;
  double scaleFactor = 1;
  double width = 200;
  double height = 200;
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
    super.initState();
    if (widget.state != null) {
      position = widget.state.position;
      lastPosition = widget.state.lastPosition;
      offset = widget.state.offset;
      width = widget.state.width;
      height = widget.state.height;
      scaleFactor = widget.state.scaleFactor;
      rotation = widget.state.rotation;
    }
    _editingController = TextEditingController(text: text);
  }

  @override
  void dispose() {
    widget.saveState({
      'position' : position,
      'lastPosition' : lastPosition,
      'offset' : offset,
      'width' : width,
      'height' : height,
      'scaleFactor' : scaleFactor,
      'rotation' : rotation,
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
              child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                        Container(
                            child: Image(
                          image: AssetImage(widget.imagePath),
                          width: width * scaleFactor,
                          height: height * scaleFactor,
                        )),
                        getTextBox()
                      ] +
                      colorFormatEditingWidgets())),
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
            if (offset.dy < 5) {
              scaleFactor /= 3;
            }
          },
          onScaleEnd: (endDetails) {
            if (offset.dy < 5) {
              widget.onDelete();
              scaleFactor /= 3;
            }
            print('stop moving **');
            widget.onStopMoving(widget.state);
          },
        ));
  }

  getTextInput() {
    print('getting text');
  }

  Widget getTextBox() {
    return widget.hasText != null
        ? Container(
            width: width * scaleFactor / 2,
            height: height * scaleFactor / 3,
            child: KeyboardActions(
                // tapOutsideToDismiss: true, //simdilik false cünkü dışarı tıklayıncaki eventi yakalayıp isediting false yapamadım
                config: KeyboardActionsConfig(
                  keyboardBarColor: Color.fromARGB(120, 0, 0, 0),
                  actions: [
                    KeyboardActionsItem(
                      focusNode: _focusNodeName,
                      onTapAction: () => {_isEditingText = false},
                    ),
                  ],
                ),
                child: _editTitleTextField()),
          )
        : Container();
  }

  Widget _editTitleTextField() {
    if (_isEditingText)
      return Center(
        child: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          focusNode: _focusNodeName,
          style: TextStyle(
              color: _textColor, fontSize: _fontSize, fontFamily: 'AdemWarren'),
          enableSuggestions: true,
          keyboardType: TextInputType.multiline,
          minLines: 1, //Normal textInputField will be displayed
          maxLines: 5, // when
          onChanged: (newValue) {
            _focusNodeName.requestFocus();
            setState(() {
              text = newValue;
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
              color: _textColor, fontSize: _fontSize, fontFamily: 'AdemWarren'),
        ));
  }

  List<Widget> colorFormatEditingWidgets() {
    if (_isEditingText)
      return [
        Positioned(
          right: 0,
          top: 0,
          width: 50,
          height: 50,
          child: Icon(
            Icons.cancel,
            color: Colors.black,
          ),
        )
      ];
    else {
      return [Container()];
    }
  }
}
