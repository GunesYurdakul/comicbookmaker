import 'package:flutter/material.dart';
import 'package:text_editor/text_editor.dart';

class EditText extends StatefulWidget {
  final double scaleFactor;
  EditText({Key key, this.title, this.scaleFactor}) : super(key: key);

  final String title;

  @override
  _EditTextState createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  final fonts = [
    'AdemWarren',
    'ComicNeue',
    'GoodDog',
    'Woodchuck',
    'OpenSans',
  ];

  String _text = 'Sample Text';
  TextAlign _textAlign = TextAlign.center;
  double _fontSize = 22;
    TextStyle _textStyle = TextStyle(
    fontSize: 22,
    color: Colors.black,
    fontFamily: 'AdemWarren',
  );
  @override
  void didUpdateWidget(covariant EditText oldWidget) {
    // TODO: implement didUpdateWidget
    print('size: ' + _textStyle.fontSize.toString());
    print(widget.scaleFactor);
    if (widget.scaleFactor != oldWidget.scaleFactor)
      _textStyle = TextStyle(
        fontSize: _fontSize * widget.scaleFactor,
        color: _textStyle.color,
        fontFamily: _textStyle.fontFamily,
      );
    super.didUpdateWidget(oldWidget);
  }

  void _tapHandler(text, textStyle, textAlign) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(
        milliseconds: 400,
      ), // how long it takes to popup dialog after button click
      pageBuilder: (_, __, ___) {
        // your widget implementation
        return Container(
          color: Colors.grey.withOpacity(0.2),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              // top: false,
              child: Container(
                child: TextEditor(
                  fonts: fonts,
                  text: text,
                  textStyle: textStyle,
                  textAlingment: textAlign,
                  onEditCompleted: (style, align, text) {
                    setState(() {
                      _text = text;
                      _textStyle = style;
                      _textAlign = align;
                      _fontSize = style.fontSize;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Stack(
      children: [
        Center(
          child: GestureDetector(
            onTap: () => _tapHandler(_text, _textStyle, _textAlign),
            child: Text(
              _text,
              style: _textStyle,
              textAlign: _textAlign,
            ),
          ),
        ),
      ],
    )));
  }
}
