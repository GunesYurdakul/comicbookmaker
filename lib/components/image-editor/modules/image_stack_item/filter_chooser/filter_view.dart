import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:projectX/comic-filters/lib/filter.dart';

class FilterView extends StatefulWidget {
  final File compressedImage;
  final String path;
  final Function(File image) onSelected;
  final String filterType;
  const FilterView({Key key, this.onSelected, this.filterType, this.compressedImage, this.path}) : super(key: key);
  @override
  _FilterViewState createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  File compressedImage;
  @override
  void initState() {
    //var de_filter = getComicFilter(widget.filterType, widget.compressedImage);
    //de_filter.apply();
    //compressedImage = File(widget.path)..writeAsBytesSync(encodePng(de_filter.output));
    compressedImage = widget.compressedImage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 5, left: 5, top:5),
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: widget.compressedImage != null ? FileImage(compressedImage) : null,
          ),
          SizedBox(height: 3,),
          Text(
            widget.filterType, 
            style: TextStyle(
              fontSize: 10, 
              fontFamily: 'Woodchuck', 
              color: Colors.black,
              decoration: TextDecoration.none,
             ),)
        ]
      ),
    );
  }
}
