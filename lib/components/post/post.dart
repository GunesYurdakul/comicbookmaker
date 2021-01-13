import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projectX/components/dynamic-layout/dynamic-layout.dart';
import 'package:projectX/components/save/save.dart';
import 'package:screenshot/screenshot.dart';

class Post extends StatefulWidget {
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  ScreenshotController screenshotController = ScreenshotController();
  
  @override
  void initState() {

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('New Post'),
          actions: [
            IconButton(
                icon: Icon(Icons.save),
                onPressed: () {
                  File _imageFile = null;
                  screenshotController.capture(pixelRatio: 2).then((File image) async {
                    setState(() {
                      _imageFile = image;
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Save(file:image)));
                    });
                  //  widget.saveState(stickerWidgets, bubbleWidgets, _image);
                   // Navigator.pop(context, image);
                  }).catchError((onError) {
                    print(onError);
                  });
                }),
          ],
        ),
      body: Screenshot(
        controller: screenshotController,
        child: DynamicLayout(
          isLayoutChosen: false,
          pageNumber: null,
      )));
  }
}
