import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectX/components/image-editor/modules/speechbubble_chooser/speechbubble.dart';
import 'package:projectX/components/image-editor/modules/speechbubble_chooser/speechbubbles.dart';
import './modules/bottombar_container.dart';
import './modules/colors_picker.dart';
import './modules/sticker_chooser/sticker.dart';
import 'package:path_provider/path_provider.dart';
import './modules/sticker_chooser/stickers.dart';
import 'package:screenshot/screenshot.dart';
import 'package:signature/signature.dart';

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
        backgroundColor: Colors.grey,
        key: scaf,
        appBar: new AppBar(
          actions: <Widget>[
            new IconButton(
                icon: Icon(Icons.clear, color: Colors.black),
                onPressed: () {
                  _controller.points.clear();
                  setState(() {});
                }),
            new IconButton(
                icon: Icon(Icons.camera, color: Colors.black),
                onPressed: () {
                  bottomsheets();
                }),
            new FlatButton(
                child: new Text("Done"),
                textColor: Colors.black,
                onPressed: () {
                  File _imageFile;
                  _imageFile = null;
                  screenshotController
                      .capture(
                          delay: Duration(milliseconds: 500), pixelRatio: 1.5)
                      .then((File image) async {
                    //print("Capture Done");
                    setState(() {
                      _imageFile = image;
                    });
                    final paths = await getExternalStorageDirectory();
                    image.copy(paths.path +
                        '/' +
                        DateTime.now().millisecondsSinceEpoch.toString() +
                        '.png');
                    Navigator.pop(context, image);
                  }).catchError((onError) {
                    print(onError);
                  });
                }),
          ],
          backgroundColor: widget.appBarColor,
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
                decoration: BoxDecoration(
                    color: widget.bottomBarColor,
                    boxShadow: [BoxShadow(blurRadius: 10.9)]),
                height: 70,
                child: new ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    BottomBarContainer(
                      colors: widget.bottomBarColor,
                      icons: Icons.brush,
                      ontap: () {
                        // raise the [showDialog] widget
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
                      },
                      title: 'Brush',
                    ),
/*                     BottomBarContainer(
                      icons: Icons.text_fields,
                      ontap: () async {
                        final value = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TextEditor()));
                        if (value.toString().isEmpty) {
                          print("true");
                        } else {
                          type.add(2);
                          fontsize.add(20);
                          offsets.add(Offset.zero);
                          multiwidget.add(value);
                        }
                      },
                      title: 'Text',
                    ), */
                    BottomBarContainer(
                      icons: Icons.delete,
                      ontap: () {
                        _controller.clear();
                        type.clear();
                        fontsize.clear();
                        offsets.clear();
                        multiwidget.clear();
                      },
                      title: 'Eraser',
                    ),
                    BottomBarContainer(
                      icons: Icons.sticky_note_2_rounded,
                      ontap: () {
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
                      },
                      title: 'Sticker',
                    ),
                    BottomBarContainer(
                      icons: Icons.sticky_note_2_rounded,
                      ontap: () {
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
                      },
                      title: 'SpeechBubble',
                    ),
                  ],
                ),
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

class ColorPiskersSlider extends StatefulWidget {
  @override
  _ColorPiskersSliderState createState() => _ColorPiskersSliderState();
}

class _ColorPiskersSliderState extends State<ColorPiskersSlider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 260,
      color: Colors.white,
      child: new Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: new Text("Slider Filter Color"),
          ),
          Divider(
            height: 1,
          ),
          SizedBox(height: 20),
          new Text("Slider Color"),
          SizedBox(height: 10),
          BarColorPicker(
              width: 300,
              thumbColor: Colors.white,
              cornerRadius: 10,
              pickMode: PickMode.Color,
              colorListener: (int value) {
                setState(() {
                  //  currentColor = Color(value);
                });
              }),
          SizedBox(height: 20),
          new Text("Slider Opicity"),
          SizedBox(height: 10),
          Slider(value: 0.1, min: 0.0, max: 1.0, onChanged: (v) {})
        ],
      ),
    );
  }
}
