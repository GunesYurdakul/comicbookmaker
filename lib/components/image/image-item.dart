import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../image-editor/image_editor_pro.dart';

class ImageItem extends StatefulWidget {
  final double width;
  final double height;
  ImageItem({Key key, this.title, this.width, this.height}) : super(key: key);
  Map<int, Widget> stickerWidgets = new Map<int, Widget>();
  Map<int, Widget> bubbleWidgets = new Map<int, Widget>();

  final String title;
  @override
  _ImageItemState createState() => _ImageItemState();
}

class _ImageItemState extends State<ImageItem> with SingleTickerProviderStateMixin {
  File _image; //image to load
  File _backgroundImage; //image to load
  Map<int, Widget> stickerWidgets;
  Map<int, Widget> bubbleWidgets;

  //List<Sticker> stickers;
  //List<SpeechBubble> speech bubbles;
  @override
  void initState() {
    print('init state***-***');
    stickerWidgets = widget.stickerWidgets;
    bubbleWidgets = widget.bubbleWidgets;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ImageItem oldWidget) {
    // TODO: implement didUpdateWidget
    stickerWidgets = widget.stickerWidgets;
    bubbleWidgets = widget.bubbleWidgets;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.height,
        width: widget.width,
        color: Colors.black,
        child: InkWell(
            child: _image != null
                ? FittedBox(
                    child: Image.file(_image),
                    fit: BoxFit.fitHeight,
                  )
                : Container(),
            onTap: () async {
              var size = getImageSize();
              _image = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new ImageEditorPro(
                            appBarColor: Colors.transparent,
                            bottomBarColor: Colors.blue,
                            height: size['height'],
                            width: size['width'],
                            stickerWidgets: stickerWidgets,
                            bubbleWidgets: bubbleWidgets,
                            image: _backgroundImage,
                            saveState: (stickers, bubbles, image) {
                              widget.stickerWidgets = stickers;
                              widget.bubbleWidgets = bubbles;
                              _backgroundImage = image;
                            },
                          )));
              setState(() {});
            }));
  }

  getImageSize() {
    var size = {};
    print(widget.width);
    print(widget.height);
    if (widget.width / MediaQuery.of(context).size.width > widget.height / MediaQuery.of(context).size.height) {
      print(1);
      size['width'] = MediaQuery.of(context).size.width;
      size['height'] = size['width'] * (widget.height / widget.width);
    } else {
      print(2);
      size['height'] = MediaQuery.of(context).size.height;
      size['width'] = size['height'] * (widget.width / widget.height);
      if (size['width'] > MediaQuery.of(context).size.width) {
        size['width'] = MediaQuery.of(context).size.width;
        size['height'] = size['width'] * (widget.height / widget.width);
      }
    }
    print(size);
    return size;
  }

  askForSize() {
    int _sliding = 0;
    final _formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                content: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CupertinoSlidingSegmentedControl(
                      children: {0: Text('Row'), 1: Text('Column')},
                      groupValue: _sliding,
                      onValueChanged: (newValue) {
                        setState(() {
                          _sliding = newValue;
                        });
                      }),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter number of rows or columns',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a number';
                      } else if (int.parse(value) > 10)
                        return 'Please enter a number not greater than 10!';
                      else {
                        return null;
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: () {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (_formKey.currentState.validate()) {
                          if (_sliding == 0) Navigator.of(context).pop();
                          // Process data.,
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ),
                ],
              ),
            )));
  }
}
