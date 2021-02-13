import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:extended_image/extended_image.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:image_editor/image_editor.dart';
import 'dart:ui';
// ignore: implementation_imports
import 'image_stack_item/filter_chooser/filters.dart';

import 'dart:async';

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
  ColorFilter colorFilter;
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
                onPressed: () async {
                  editorKey.currentState.editAction;
                  var _img = editorKey.currentState.image;
                  Uint8List cropped = await cropImageDataWithNativeLibrary(state: editorKey.currentState);
//                  Image img = Image.fromBytes(_img.width,_img.height,cropped);
                  Navigator.of(context).pop(File(widget.image.path)..writeAsBytesSync(cropped));
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
//          colorBlendMode: BlendMode.hue,
//          color: Colors.black,
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
            child: Material(
                color: Colors.transparent,
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
                  },
                  onColorFilterSelected: (colorFilter) {
                    colorFilter = colorFilter;
                  },
                )));
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }

  Future<Uint8List> _cropImage() async {
    String msg = '';
    _cropping = true;
    Uint8List fileData;
    fileData = Uint8List.fromList(await cropImageDataWithNativeLibrary(state: editorKey.currentState));
    return fileData;
  }

  Future<List<int>> cropImageDataWithNativeLibrary({ExtendedImageEditorState state}) async {
    print('native library start cropping');

    final Rect cropRect = state.getCropRect();
    final EditActionDetails action = state.editAction;

    final int rotateAngle = action.rotateAngle.toInt();
    final bool flipHorizontal = action.flipY;
    final bool flipVertical = action.flipX;
    final Uint8List img = state.rawImageData;

    final ImageEditorOption option = ImageEditorOption();

    if (action.needCrop) {
      option.addOption(ClipOption.fromRect(cropRect));
    }

    if (action.needFlip) {
      option.addOption(FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
    }

    if (action.hasRotateAngle) {
      option.addOption(RotateOption(rotateAngle));
    }

    final DateTime start = DateTime.now();
    final Uint8List result = await ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );

    print('${DateTime.now().difference(start)} ：total time');
    return result;
  }
}
