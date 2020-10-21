import 'package:flutter/material.dart';
import 'dart:math';
import 'package:screenshot/screenshot.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class SpeechBubbleView extends StatefulWidget {
  final double left;
  final double top;
  final Function(ScaleStartDetails) onScaleStart;
  final Function(ScaleUpdateDetails) onScaleUpdate;
  final double fontsize;
  final String value;
  _SpeechBubbleViewState state=_SpeechBubbleViewState();
  SpeechBubbleView(
      // color, fontsize ve fontu parametre olarak al
      // hareket halindeyken de bir şeyler emit falan etsin kii çöp kutusu çıkısn
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
    if(widget.state!=null){
      position = widget.state.position;
      lastPosition = widget.state.lastPosition;
      offset = widget.state.offset;
      width = widget.state.width;
      height = widget.state.height;
      _scaleFactor = widget.state._scaleFactor;
      rotation = widget.state.rotation;
      }  
      _editingController = TextEditingController(text: text);
  }

  @override
  void dispose() {
    _editingController.dispose();
    widget.state.position = position;
    widget.state.offset = offset;
    widget.state.rotation = rotation;
    widget.state.lastPosition = lastPosition;
    widget.state.width = width;
    widget.state.height = height;
    widget.state._scaleFactor = _scaleFactor;
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
                          image: AssetImage(widget.value),
                          width: width * _scaleFactor,
                          height: height * _scaleFactor,
                        )),
                        Container(
                          width: width * _scaleFactor / 2,
                          height: height * _scaleFactor / 3,
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
                        ),
                      ] +
                      colorFormatEditingWidgets())),
          onScaleStart: (details) {
            _baseScaleFactor = _scaleFactor;
            lastPosition = details.localFocalPoint;
          },
          onScaleUpdate: (details) {
            setState(() {
              print(rotation);
              _scaleFactor = _baseScaleFactor * details.scale;
              offset -= (lastPosition - details.localFocalPoint);
              position = offset;
              rotation += details.rotation;
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
