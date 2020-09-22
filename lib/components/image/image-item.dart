import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../image-picker/image-picker.dart';

class ImageItem extends StatefulWidget {
  ImageItem({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _ImageItemState createState() => _ImageItemState();
}

class _ImageItemState extends State<ImageItem>
    with SingleTickerProviderStateMixin {
  Image image; //image to load
  //List<Sticker> stickers;
  //List<SpeechBubble> speech bubbles;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(10),
        color: Colors.black,
        child: InkWell(
            child: Container(
              child: Text('Image is going to be here'),
              //insert image here//
            ),
            onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImageItemPicker()),
                )));
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
