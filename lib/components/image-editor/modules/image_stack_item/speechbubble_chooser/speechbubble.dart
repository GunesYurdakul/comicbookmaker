import 'package:flutter/material.dart';
import 'package:projectX/components/image-editor/modules/image_stack_item/animated_stack_item.dart';
import 'dart:math';
import 'package:screenshot/screenshot.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class SpeechBubbleView extends StatefulWidget {
  final String value;
  final VoidCallback onMoving;
  SpeechBubbleView(
      // color, fontsize ve fontu parametre olarak al
      // hareket halindeyken de bir şeyler emit falan etsin kii çöp kutusu çıkısn
      {Key key,
      this.value,
      this.onMoving})
      : super(key: key);
  @override
  _SpeechBubbleViewState createState() => _SpeechBubbleViewState();
}

class _SpeechBubbleViewState extends State<SpeechBubbleView> {
  double _fontSize = 15;
  Color _textColor = Colors.black;
  String text = 'Text';
  bool _isEditingText = false;
  TextEditingController _editingController;
  final _focusNodeName = FocusNode();

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
    return Stack(
      children: [
        AnimatedStackItem(
          imagePath: widget.value,
          onMoving: () => {widget.onMoving()},
        ),
        //_editTitleTextField()
      ],
    );
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
