import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
            height: MediaQuery.of(context).size.width / 2,
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
            margin: EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text('Gallery'),
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
                  leading: Icon(Icons.image),
                  title: Text('Instagram'),
                ),
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text('Facebook'),
                ),
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text('Messenger'),
                ),
              ],
            ))
      ]),
    );
  }
}
