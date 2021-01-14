import 'dart:io';

import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/rendering.dart';

import 'image_stack_item/filter_chooser/filters.dart';

class BasicImageEditor extends StatefulWidget {
  final File image;

  const BasicImageEditor({Key key, this.image}) : super(key: key);
  @override
  _BasicImageEditorState createState() => _BasicImageEditorState();
}

class _BasicImageEditorState extends State<BasicImageEditor> {
  final GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey<ExtendedImageEditorState>();
  bool _cropping = false;
  String filter;
  double _cropAspectRatio;
  File _filteredImage;
  @override
  void initState() {
    _filteredImage = widget.image;
    _cropAspectRatio = CropAspectRatios.custom;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  Navigator.of(context).pop();
                  //editorKey.currentState.image.
                })
          ],
        ),
        bottomNavigationBar: Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.filter),
                  onPressed: () {
                    showFiltersChooser();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.crop),
                  onPressed: () {
                    cropImage();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.rotate_left),
                  onPressed: () {
                    editorKey.currentState.rotate(right: false);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.rotate_right),
                  onPressed: () {
                    editorKey.currentState.rotate(right: true);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.flip),
                  onPressed: () {
                    editorKey.currentState.flip();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.settings_backup_restore),
                  onPressed: () {
                    editorKey.currentState.reset();
                  },
                ),
              ],
            )),
        body: ExtendedImage.file(
          _filteredImage,
          fit: BoxFit.contain,
          mode: ExtendedImageMode.editor,
          extendedImageEditorKey: editorKey,
          initEditorConfigHandler: (state) {
            return EditorConfig(maxScale: 8.0, hitTestSize: 20.0, cropAspectRatio: _cropAspectRatio);
          },
        ));
  }

  Future<void> cropImage() async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
            ),
            margin: EdgeInsets.only(bottom: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [Icon(Icons.crop_original), Text('')]),
                  onPressed: () {
                    setAspectRatio(CropAspectRatios.original);
                  },
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [Icon(Icons.crop_free), Text('free')]),
                  onPressed: () {
                    setAspectRatio(CropAspectRatios.custom);
                  },
                ),
                IconButton(
                  iconSize: 70,
                  icon: getAspectRatioIcon(CropAspectRatios.ratio16_9, '16x9'),
                  onPressed: () {
                    setAspectRatio(CropAspectRatios.ratio16_9);
                  },
                ),
                IconButton(
                  iconSize: 70,
                  icon: getAspectRatioIcon(CropAspectRatios.ratio9_16, '9x16'),
                  onPressed: () {
                    setAspectRatio(CropAspectRatios.ratio9_16);
                  },
                ),
                IconButton(
                  iconSize: 70,
                  icon: getAspectRatioIcon(CropAspectRatios.ratio1_1, '1x1'),
                  onPressed: () {
                    setAspectRatio(CropAspectRatios.ratio1_1);
                  },
                ),
                IconButton(
                  iconSize: 70,
                  icon: getAspectRatioIcon(CropAspectRatios.ratio3_4, '3x4'),
                  onPressed: () {
                    setAspectRatio(CropAspectRatios.ratio3_4);
                  },
                ),
                IconButton(
                  iconSize: 70,
                  icon: getAspectRatioIcon(CropAspectRatios.ratio4_3, '4x3'),
                  onPressed: () {
                    setAspectRatio(CropAspectRatios.ratio4_3);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getAspectRatioIcon(double ratio, String label) {
    double scale = ratio > 1 ? 15 : 20;
    double height = scale;
    double width = scale * ratio;
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      SizedBox(
        height: height,
        width: width,
        child: Container(
          decoration: BoxDecoration(border: Border.all(width: 2)),
          height: height,
          width: width,
        ),
      ),
      Text(label)
    ]);
  }

  setAspectRatio(double ratio) {
    setState(() {
      _cropAspectRatio = ratio;
    });
  }

  showFiltersChooser() {
    return showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      transitionDuration: Duration(milliseconds: 200),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
            alignment: Alignment.bottomCenter,
            child: Filters(
                filter: this.filter,
                image: widget.image,
                loading: () {
                  this.setState(() {
                    print('loading');
                  });
                },
                onSelected: (filteredImage, filter) {
                  setState(() {
                    this._filteredImage = filteredImage;
                    this.filter = filter;
                  });
                }));
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }
}
