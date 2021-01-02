import 'dart:async';
import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectX/components/image-editor/modules/image_stack_item/speechbubble_chooser/speechbubble.dart';
import './modules/image_stack_item/sticker_chooser/sticker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:signature/signature.dart';

import 'modules/image_stack_item/filter_chooser/filters.dart';
import 'modules/image_stack_item/image_menu_bottom_sheet.dart';

TextEditingController heightcontroler = TextEditingController();
TextEditingController widthcontroler = TextEditingController();

List fontsize = [];
List multiwidget = [];

Color currentcolors = Colors.white;
var opicity = 0.0;
SignatureController _controller = SignatureController(penStrokeWidth: 5, penColor: Colors.green);

class ImageEditorPro extends StatefulWidget {
  final Color appBarColor;
  final double width;
  final double height;
  final Color bottomBarColor;
  final Map<int, Widget> stickerWidgets;
  final Map<int, Widget> bubbleWidgets;
  final File image;
  final void Function(Map<int, Widget> stickers, Map<int, Widget> bubbles, File _image) saveState;
  ImageEditorPro({this.width, this.height, this.appBarColor, this.bottomBarColor, this.saveState, this.stickerWidgets, this.bubbleWidgets, this.image});
  @override
  _ImageEditorProState createState() => _ImageEditorProState();
}

var slider = 0.0;

class _ImageEditorProState extends State<ImageEditorPro> {
  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  Map<int, Widget> stickerWidgets;
  Map<int, Widget> bubbleWidgets;
  File _image;

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
    var points = _controller.points;
    _controller = SignatureController(penStrokeWidth: 5, penColor: color, points: points);
  }

  Offset offset1 = Offset.zero;
  Offset offset2 = Offset.zero;
  final scaf = GlobalKey<ScaffoldState>();
  var openbottomsheet = false;
  List<Offset> _points = <Offset>[];
  List type = [];
  List aligment = [];
  File _imageFile;
  File filteredImage;
  String filter;
  bool loading = false;
  bool moving = false;
  int movingIndex;

  final GlobalKey container = GlobalKey();
  final GlobalKey globalKey = new GlobalKey();
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
    print('DISPOSE');
    super.dispose();
    timeprediction.cancel();
    _controller.clear();
  }

  @override
  void initState() {
    print('init state');
    super.initState();
    bubbleWidgets = widget.bubbleWidgets;
    stickerWidgets = widget.stickerWidgets;
    _image = widget.image;
    timers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        key: scaf,
        appBar: new AppBar(
          actions: <Widget>[
            new IconButton(
                icon: Icon(Icons.add_a_photo, color: Colors.white),
                onPressed: () {
                  bottomsheets();
                }),
            new IconButton(
                icon: Icon(Icons.check, color: Colors.white),
                onPressed: () {
                  _imageFile = null;
                  screenshotController.capture(pixelRatio: 6).then((File image) async {
                    setState(() {
                      _imageFile = image;
                    });
                    widget.saveState(stickerWidgets, bubbleWidgets, _image);
                    Navigator.pop(context, image);
                  }).catchError((onError) {
                    print(onError);
                  });
                }),
          ],
        ),
        body: Center(
          child: Screenshot(
            controller: screenshotController,
            child: Container(
              margin: EdgeInsets.all(20),
              color: Colors.white,
              width: widget.width,
              height: widget.height,
              child: RepaintBoundary(
                  key: globalKey,
                  child: Stack(
                    children: <Widget>[
                      filteredImage != null
                          ? Image.file(
                              filteredImage,
                              height: widget.height,
                              width: widget.width,
                              fit: BoxFit.cover,
                            )
                          : (_image != null
                              ? Image.file(
                                  _image,
                                  height: widget.height,
                                  width: widget.width,
                                  fit: BoxFit.cover,
                                )
                              : Container()),
                      Container(
                        child: GestureDetector(
                            onPanUpdate: (DragUpdateDetails details) {
                              setState(() {
                                RenderBox object = context.findRenderObject();
                                Offset _localPosition = object.globalToLocal(details.globalPosition);
                                _points = new List.from(_points)..add(_localPosition);
                              });
                            },
                            onPanEnd: (DragEndDetails details) {
                              _points.add(null);
                            },
                            child: Signat(
                              width: widget.width,
                              height: widget.height,
                            )),
                      ),
                      Stack(
                        children: stickerWidgets.values.toList().asMap().entries.map((f) {
                          return f.value;
                        }).toList(),
                      ),
                      Stack(
                        children: bubbleWidgets.values.toList().asMap().entries.map((f) {
                          return f.value;
                        }).toList(),
                      ),
                      Visibility(
                          visible: moving,
                          child: Container(
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Icon(Icons.delete_outline, size: 40, color: Colors.white,),
                          ]))),
                      this.loading
                          ? Center(
                              child: CircularProgressIndicator(
                              backgroundColor: Colors.cyanAccent,
                              valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                            ))
                          : Container()
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
                  backgroundColor: Colors.transparent,
                  items: <Widget>[
                    Icon(Icons.filter, size: 30),
                    Icon(Icons.chat_bubble_outline, size: 30),
                    Icon(Icons.filter_frames, size: 30),
                    Icon(Icons.gesture, size: 30),
                    FaIcon(FontAwesomeIcons.eraser, size: 25),
                  ],
                  onTap: (index) {
                    switch (index) {
                      case 0:
                        Future getStickers = showFiltersChooser();
                        getStickers.then((value) {
                          if (value != null) {}
                        });

                        print('filters');
                        break;
                      case 1:
                        Future getStickers = showChooserDialog('stickers');
                        getStickers.then((value) {
                          if (value != null) {
                            int key = stickerWidgets.length;

                            stickerWidgets[key] = new StickerView(
                              value: value,
                              onMoving: () {
                                toggleTrashBin(true);
                                movingIndex = key;
                              },
                              onStopMoving: (state) {
                                print('stop');
                                toggleTrashBin(false);
                              },
                              onDelete: () {
                                stickerWidgets.remove(movingIndex);
                                print('delete');
                              },
                            );
                          }
                        });
                        break;
                      case 2:
                        Future getBubbles = showChooserDialog('speechbubbles');
                        getBubbles.then((value) {
                          if (value != null) {
                            int key = bubbleWidgets.length;
                            bubbleWidgets[key] = new SpeechBubbleView(
                              value: value,
                              onMoving: () {
                                toggleTrashBin(true);
                                movingIndex = key;
                                print('moving widget' + moving.toString());
                              },
                              onStopMoving: (state) {
                                print('stop');
                                moving = true;
                                toggleTrashBin(false);
                              },
                              onDelete: () {
                                bubbleWidgets.remove(movingIndex);
                                print('delete');
                              },
                            );
                          }
                        });
                        break;
                      case 3:
                        brush();
                        break;
                      case 4:
                        _controller.clear();
                        type.clear();
                        break;
                      default:
                        print(index);
                    }
                  },
                ),
              ));
  }

  toggleTrashBin(bool value) {
    print(this.mounted);
    if (this.mounted)
      setState(() {
        moving = value;
      });
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

  showChooserDialog(type) {
    return showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 200),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 300,
            child: SizedBox.expand(child: ImageMenuBottomSheet(pathKey:type)),
            margin: EdgeInsets.only(bottom: 90, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
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
                image: _image,
                loading: () {
                  this.setState(() {
                    print('loading');
                    this.loading = true;
                  });
                },
                onSelected: (filteredImage, filter) {
                  setState(() {
                    this.filteredImage = filteredImage;
                    this.filter = filter;
                    this.loading = false;
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

  void bottomsheets() {
    openbottomsheet = true;
    setState(() {
      filter = 'None';
    });
    Future<void> future = showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return new Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(blurRadius: 10.9, color: Colors.grey[400])]),
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
                                    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                                    var decodedImage = await decodeImageFromList(image.readAsBytesSync());

                                    setState(() {
                                      _image = image;
                                      filteredImage = null;
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
                                  var image = await ImagePicker.pickImage(source: ImageSource.camera);
                                  var decodedImage = await decodeImageFromList(image.readAsBytesSync());

                                  setState(() {
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
  final double width;
  final double height;

  const Signat({Key key, this.width, this.height}) : super(key: key);
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
        Signature(controller: _controller, height: widget.height, width: widget.width, backgroundColor: Colors.transparent),
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
                    fontsize[widget.size] = v.toInt();
                  });
                }),
          ],
        ));
  }
}
