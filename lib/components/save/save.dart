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
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 15),
            height: MediaQuery.of(context).size.height / 2,
            alignment: Alignment.center,
            child: widget.file != null
                ? FittedBox(
                    child: Image.file(
                      widget.file,
                    ),
                    fit: BoxFit.fitHeight,
                  )
                : Container()),
        SizedBox(
          height: 20,
        ),
        Container(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.save),
                  title: Text('Save to Gallery'),
                  onTap: () async {
                    final result = await ImageGallerySaver.saveImage(widget.file.readAsBytesSync());
                    print(result);
                    Fluttertoast.showToast(
                        msg: result['isSuccess']?'Saved':'Failed',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: result['isSuccess']?Colors.green:Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.share),
                  title: Text('Share'),
                  onTap: (){
                    Share.shareFiles([widget.file.path], text: 'Great picture');
                  },
                ),
              ],
            ))
      ]),
    );
  }
}
