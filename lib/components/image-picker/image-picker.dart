import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:flutter/material.dart';

//https://pub.dev/packages/image_picker
//https://pub.dev/packages/image_picker/example(more detailed-galeri de var)
//***Galiba bununla hem galeriden hem kameradan çekim oluyor***/
class ImageItemPicker extends StatefulWidget {
  @override
  _ImageItemPickerState createState() => _ImageItemPickerState();
}

class _ImageItemPickerState extends State<ImageItemPicker> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Center(
        child: _image == null ? Text('No image selected.') : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
