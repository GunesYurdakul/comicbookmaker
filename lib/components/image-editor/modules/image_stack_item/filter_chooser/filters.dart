import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projectX/comic-filters/comic_filters.dart';
import 'package:projectX/comic-filters/lib/filter.dart';
import 'package:projectX/components/image-editor/modules/image_stack_item/filter_chooser/filter_view.dart';

class Filters extends StatefulWidget {
  final File image;
  final Function(File image) onSelected;
  const Filters({Key key, this.image, this.onSelected}) : super(key: key);
  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  List<String> filters = ['DetailEnhancement', 'PencilSketch', 'PencilEdges', 'Quantization', 'Quantization2'];//Biliteral
  File smallImage;
  File previewImage;
  File filteredImage;
  Map<String, File> filterPrevImages = Map<String, File>();
  String path;
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<File>(
        future: _getCompressedImage(),
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.hasData)
            return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.only(bottom: 90, left: 12, right: 12),
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: filters.map((filter) {
                    if (!filterPrevImages.containsKey(filter)) {
                      var prev_filter = getComicFilter(filter, previewImage.path);
                      prev_filter.apply();
                      filterPrevImages[filter] = File('$path/$filter-prevfiltered.png')..writeAsBytesSync(encodePng(prev_filter.output));
                    }
                    return GestureDetector(
                        onTap: () {
                          if (filter == '') {
                            widget.onSelected(widget.image);
                          } else {
                            print(filter);
                            var de_filter = getComicFilter(filter, smallImage.path);
                            de_filter.apply();
                            print('image processed1');
                            widget.onSelected(File('$path/$filter-filtered.png')..writeAsBytesSync(encodePng(de_filter.output)));
                            print('image processed2');
                          }
                        },
                        child: FilterView(compressedImage: filterPrevImages[filter], filterType: filter, path: '$path/$filter.png'));
                  }).toList(),
                ));
          else
            return Container();
        });
  }

  Future<File> _getCompressedImage() async {
    if (widget.image != null) smallImage = await compressFile(widget.image, 80);
    if (widget.image != null) previewImage = await compressFile(widget.image, 0);
    final directory = await getApplicationDocumentsDirectory();
    path = directory.path;
    return smallImage;
  }

  @override
  void initState() {
    super.initState();
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
