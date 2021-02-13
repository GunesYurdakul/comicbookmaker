import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/filter_bloc.dart';

class ClassicFilterView extends StatefulWidget {
  final File compressedImage;
  final String path;
  final String groupValue;
  final Function(ColorFilter filter) onSelected;
  final ColorFilter filterType;
  const ClassicFilterView({Key key, this.onSelected, this.filterType, this.compressedImage, this.path, this.groupValue}) : super(key: key);
  @override
  _ClassicFilterViewState createState() => _ClassicFilterViewState();
}

class _ClassicFilterViewState extends State<ClassicFilterView> {
  File compressedImage;
  String path;
  String groupValue;
  @override
  void initState() {
    path = widget.path;
    groupValue = widget.groupValue;
    compressedImage = widget.compressedImage;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ClassicFilterView oldWidget) {
    setState(() {
      print(widget.groupValue + 'sele');
      groupValue = widget.groupValue;
    });
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
              padding: EdgeInsets.only(right: 5, left: 5, top: 5),
              child: GestureDetector(
                onTap: () => widget.onSelected(widget.filterType),
                child: Column(children: [
                  Container(
                    width: 75.0,
                    height: 75.0,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        colorFilter: widget.filterType,
                        image: new FileImage(compressedImage),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                      border: new Border.all(
                        color: Colors.blue,
                        width: groupValue == widget.filterType ? 3.0 : 0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    '',
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Woodchuck',
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  )
                ]),
              ));
  }
}
