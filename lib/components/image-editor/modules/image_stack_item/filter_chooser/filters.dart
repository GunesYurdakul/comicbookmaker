import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projectX/comic-filters/comic_filters.dart';
import 'package:projectX/comic-filters/lib/filter.dart';
import 'package:projectX/components/image-editor/modules/image_stack_item/filter_chooser/filter_view.dart';

class Filters extends StatefulWidget {
  final File image;
  final String filter;
  final Function(File image, String filter) onSelected;
  const Filters({Key key, this.image, this.onSelected, this.filter}) : super(key: key);
  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  List<String> filters = ['None', 'DetailEnhancement', 'PencilSketch', 'PencilEdges', 'Quantization', 'Quantization2', 'PopArt1', 'PopArt2', 'PopArt3']; //, 'PopArt1', 'PopArt2', 'PopArt3', Biliteral
  File smallImage;
  File previewImage;
  File filteredImage;
  String selected;
  String path;
  @override
  void initState() {
    selected = widget.filter != null ?widget.filter:'None';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<File>(
        future: _getCompressedImage(),
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.hasData) {
            return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.only(bottom: 90, left: 12, right: 12),
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(filters.length, (index) {
                    String filter = filters[index];
                    String filterPath = '$path/$filter-${basename(widget.image.path)}-filtered.png';
                    return FilterView(
                        onSelected: (val) async {
                          if(val=='None')
                            widget.onSelected(widget.image, val);
                          setState(() {
                            selected = val;
                          });
                          if(File(filterPath).existsSync())
                            widget.onSelected(File(filterPath), val);
                          else{
                            var de_filter = getComicFilter(val, widget.image.path);
                            await de_filter.apply();
                            print('image processed1');
                            widget.onSelected(File(filterPath)..writeAsBytesSync(encodePng(de_filter.output)), val);
                            print('image processed2');
                          }
                        },
                        groupValue: selected,
                        compressedImage: smallImage,
                        filterType: filter,
                        path: '$path/$filter-${basename(widget.image.path)}-smallfiltered.png');
                  }),
                ));
          } else
            return Container();
        });
  }

  Future<File> _getCompressedImage() async {
    //lengthSync
    if (widget.image != null) smallImage = await compressFile(widget.image, 70);
    if (widget.image != null) previewImage = await compressFile(widget.image, 0);
    final directory = await getApplicationDocumentsDirectory();
    path = directory.path;
    print("returning small image");
    return smallImage;
  }


  Future<File> compressFile(File file, int quality) async {
    final filePath = file.absolute.path;
    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: quality,
    );
    print(file.lengthSync());
    print(result.lengthSync());
    return result;
  }
}
