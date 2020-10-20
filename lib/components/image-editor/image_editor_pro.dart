import 'dart:async';
import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectX/components/image-editor/modules/speechbubble_chooser/speechbubble.dart';
import './modules/colors_picker.dart';
import './modules/sticker_chooser/sticker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:signature/signature.dart';

import 'modules/speechbubble_chooser/speechbubbles.dart';
import 'modules/sticker_chooser/stickers.dart';

TextEditingController heightcontroler = TextEditingController();
TextEditingController widthcontroler = TextEditingController();

int width = 800;
int height = 800;
List fontsize = [];
List multiwidget = [];
List stickerWidget = [];
List bubbleWidget = [];
Color currentcolors = Colors.white;
var opicity = 0.0;
SignatureController _controller =
    SignatureController(penStrokeWidth: 5, penColor: Colors.green);

class ImageEditorPro extends StatefulWidget {
  final Color appBarColor;
  final int width;
  final int height;
  final Color bottomBarColor;
  ImageEditorPro(
      {this.width, this.height, this.appBarColor, this.bottomBarColor});
  @override
  _ImageEditorProState createState() => _ImageEditorProState();
}

var slider = 0.0;

class _ImageEditorProState extends State<ImageEditorPro> {
  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
    var points = _controller.points;
    _controller =
        SignatureController(penStrokeWidth: 5, penColor: color, points: points);
  }

  List<Offset> offsets = [];
  Offset offset1 = Offset.zero;
  Offset offset2 = Offset.zero;
  final scaf = GlobalKey<ScaffoldState>();
  var openbottomsheet = false;
  List<Offset> _points = <Offset>[];
  List type = [];
  List aligment = [];
  File _imageFile;

  final GlobalKey container = GlobalKey();
  final GlobalKey globalKey = new GlobalKey();
  File _image;
  ScreenshotController screenshotController = ScreenshotController();
  Timer timeprediction;
  void timers() {
    Timer.periodic(Duration(milliseconds: 10), (tim) {
      setState(() {});
      timeprediction = tim;
    });
  }

  @override
  void dispose() {
    timeprediction.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    timers();
    _controller.clear();
    type.clear();
    fontsize.clear();
    offsets.clear();
    multiwidget.clear();
    width = widget.width;
    width = widget.height;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        key: scaf,
        appBar: new AppBar(
          actions: <Widget>[
            new IconButton(
                icon: Icon(Icons.add_a_photo, color: Colors.black),
                onPressed: () {
                  bottomsheets();
                }),
            new IconButton(
                icon: Icon(Icons.check, color: Colors.black),
                onPressed: () {
                  _imageFile = null;
                  screenshotController.capture(
                    pixelRatio: 6
                  ).then((File image) async {
                    setState(() {
                      _imageFile = image;
                    });
                    final paths = await getExternalStorageDirectory();
                    await image.copy(paths.path +
                        '/' +
                        DateTime.now().millisecondsSinceEpoch.toString() +
                        '.png');
                    Navigator.pop(context, image);
                  }).catchError((onError) {
                    print(onError);
                  });
                }),
          ],
          backgroundColor: Colors.pink,
        ),
        body: Center(
          child: Screenshot(
            controller: screenshotController,
            child: Container(
              margin: EdgeInsets.all(20),
              color: Colors.white,
              width: width.toDouble(),
              height: height.toDouble(),
              child: RepaintBoundary(
                  key: globalKey,
                  child: Stack(
                    children: <Widget>[
                      _image != null
                          ? Image.file(
                              _image,
                              height: height.toDouble(),
                              width: width.toDouble(),
                              fit: BoxFit.cover,
                            )
                          : Container(),
                      Stack(
                        children: stickerWidget.asMap().entries.map((f) {
                          return StickerView(
                            value: f.value,
                          );
                        }).toList(),
                      ),
                      Stack(
                        children: bubbleWidget.asMap().entries.map((f) {
                          return SpeechBubbleView(
                            value: f.value,
                          );
                        }).toList(),
                      )
                    ],
                  )),
            ),
          ),
        ),
        bottomNavigationBar: openbottomsheet
            ? new Container()
            : Container(
                child: CurvedNavigationBar(
                  animationDuration: Duration(milliseconds: 200),
                  backgroundColor: Colors.pinkAccent[700],
                  items: <Widget>[
                    Icon(Icons.chat_bubble_outline, size: 30),
                    Icon(Icons.filter_frames, size: 30),
                    Icon(Icons.gesture, size: 30),
                  ],
                  onTap: (index) {
                    switch (index) {
                      case 0:
                        Future getemojis = showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Stickers();
                            });
                        getemojis.then((value) {
                          if (value != null) {
                            print(value);
                            offsets.add(Offset.zero);
                            stickerWidget.add(value);
                          }
                        });
                        break;
                      case 1:
                        Future getBubbles = showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return SpeechBubbles();
                            });
                        getBubbles.then((value) {
                          if (value != null) {
                            print(value);
                            offsets.add(Offset.zero);
                            bubbleWidget.add(value);
                          }
                        });
                        break;
                      case 2:
                        brush();
                        break;
                      default:
                        print(index);
                    }
                  },
                ),
              ));
  }

  brush() {
    showDialog(
        context: context,
        child: AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: changeColor,
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('Got it'),
              onPressed: () {
                setState(() => currentColor = pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }

  void bottomsheets() {
    openbottomsheet = true;
    setState(() {});
    Future<void> future = showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return new Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(blurRadius: 10.9, color: Colors.grey[400])
          ]),
          height: 170,
          child: new Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: new Text("Select Image Options"),
              ),
              Divider(
                height: 1,
              ),
              new Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.photo_library),
                                  onPressed: () async {
                                    var image = await ImagePicker.pickImage(
                                        source: ImageSource.gallery);
                                    var decodedImage =
                                        await decodeImageFromList(
                                            image.readAsBytesSync());

                                    setState(() {
                                      height = decodedImage.height;
                                      width = decodedImage.width;
                                      _image = image;
                                    });
                                    setState(() => _controller.clear());
                                    Navigator.pop(context);
                                  }),
                              SizedBox(width: 10),
                              Text("Open Gallery")
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 24),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.camera_alt),
                                onPressed: () async {
                                  var image = await ImagePicker.pickImage(
                                      source: ImageSource.camera);
                                  var decodedImage = await decodeImageFromList(
                                      image.readAsBytesSync());

                                  setState(() {
                                    height = decodedImage.height;
                                    width = decodedImage.width;
                                    _image = image;
                                  });
                                  setState(() => _controller.clear());
                                  Navigator.pop(context);
                                }),
                            SizedBox(width: 10),
                            Text("Open Camera")
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
    future.then((void value) => _closeModal(value));
  }

  void _closeModal(void value) {
    openbottomsheet = false;
    setState(() {});
  }
}

class Signat extends StatefulWidget {
  @override
  _SignatState createState() => _SignatState();
}

class _SignatState extends State<Signat> {
  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print("Value changed"));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Signature(
            controller: _controller,
            height: height.toDouble(),
            width: width.toDouble(),
            backgroundColor: Colors.transparent),
      ],
    );
  }
}

class Sliders extends StatefulWidget {
  final int size;
  final sizevalue;
  const Sliders({Key key, this.size, this.sizevalue}) : super(key: key);
  @override
  _SlidersState createState() => _SlidersState();
}

class _SlidersState extends State<Sliders> {
  @override
  void initState() {
    slider = widget.sizevalue;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 120,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: new Text("Slider Size"),
            ),
            Divider(
              height: 1,
            ),
            new Slider(
                value: slider,
                min: 0.0,
                max: 100.0,
                onChangeEnd: (v) {
                  setState(() {
                    fontsize[widget.size] = v.toInt();
                  });
                },
                onChanged: (v) {
                  setState(() {
                    slider = v;
                    print(v.toInt());
                    fontsize[widget.size] = v.toInt();
                  });
                }),
          ],
        ));
  }
}
