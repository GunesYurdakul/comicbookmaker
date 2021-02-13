import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';

class Save extends StatefulWidget {
  final File file;

  const Save({Key key, this.file}) : super(key: key);
  @override
  _SaveState createState() => _SaveState();
}

class _SaveState extends State<Save> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Save')),
      body: Column(children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 20),
          height: MediaQuery.of(context).size.height / 1.5,
          alignment: Alignment.center,
          child: widget.file != null
              ? FittedBox(
                  child: Image.file(
                    widget.file,
                  ),
                  fit: BoxFit.fitHeight,
                )
              : Container()
        ),
        SizedBox(
          height: 20,
        ),
        Container(
            width: 250,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                stylishButton(
                  'Save',
                  Icons.save,
                  () async {
                    final result = await ImageGallerySaver.saveImage(widget.file.readAsBytesSync());
                    print(result);
                    Fluttertoast.showToast(
                        msg: result['isSuccess'] ? 'Saved' : 'Failed',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: result['isSuccess'] ? Colors.green[200] : Colors.red[100],
                        textColor: Colors.white,
                        fontSize: 16.0);
                  },
                ),
                stylishButton(
                  'Share',
                  Icons.share,
                  ()=> Share.shareFiles([widget.file.path], text: 'Great picture')
                ),
              ],
            ))
      ]),
    );
  }

  stylishButton(String text, IconData icon, Function onPressed) {
    return RaisedButton(
      onPressed: () => onPressed(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      padding: EdgeInsets.all(0.0),
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink[100], Colors.pink[50]],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30.0)),
        child: Container(
          constraints: BoxConstraints(maxWidth: 120.0, minHeight: 50.0),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(icon, color: Colors.white),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ])
        ),
      ),
    );
  }
}
