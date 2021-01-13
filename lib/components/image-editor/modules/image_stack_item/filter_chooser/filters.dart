import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projectX/comic-filters/lib/filter.dart';
import 'package:projectX/components/image-editor/modules/image_stack_item/filter_chooser/filter_view.dart';

class Filters extends StatefulWidget {
  final File image;
  final String filter;
  final Function(File image, String filter) onSelected;
  final Function() loading;
  const Filters({Key key, this.image, this.onSelected, this.filter, this.loading}) : super(key: key);
  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  List<String> filters = [
    'None',
    'DetailEnhancement',
    'Bilateral',
    'PencilSketch',
    'PencilEdges',
    'Quantization',
    'Quantization1',
    'Quantization2',
    'PopArt1',
    'PopArt2',
    'PopArt3',
  ]; //, 'PopArt1', 'PopArt2', 'PopArt3', Biliteral
  File smallImage;
  File previewImage;
  File filteredImage;
  String selected;
  String path;
  @override
  void initState() {
    selected = widget.filter != null ? widget.filter : 'None';
    print('init' + selected);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Filters oldWidget) {
    // TODO: implement didUpdateWidget
    setState(() {
      selected = widget.filter;
    });
    super.didUpdateWidget(oldWidget);
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
                          setState(() {
                            widget.loading();
                            selected = val;
                          });
                          await Future.delayed(const Duration(milliseconds: 50), () {});
                          if (val == 'None')
                            widget.onSelected(widget.image, val);
                          else {
                            if (File(filterPath).existsSync())
                              widget.onSelected(File(filterPath), val);
                            else {
                              File outputImage =  await _getFilteredImage(filterPath, smallImage, filter);
                              widget.onSelected(outputImage, val);
                              print('image processed2');
                            }
                          }
                        },
                        groupValue: selected,
                        compressedImage: previewImage,
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
    if (widget.image != null) smallImage = await compressFile(widget.image, 60, 1000);
    if (widget.image != null) previewImage = await compressFile(widget.image, 0, 200);
    final directory = await getApplicationDocumentsDirectory();
    path = directory.path;
    print("returning small image");
    print('small' + smallImage.lengthSync().toString());
    print('preview' + previewImage.lengthSync().toString());
    return smallImage;
  }

  Future<File> compressFile(File file, int quality, int width) async {
    final filePath = file.absolute.path;
    // Create output file path
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}${quality}_out${filePath.substring(lastIndex)}";

    File imageFile = await FlutterImageCompress.compressAndGetFile(file.absolute.path, outPath, minWidth: width, minHeight: width, quality: quality);
    File result = new File(imageFile.path);

    return result;
  }

  Future<File> _getFilteredImage(String path, File compressedImage, String filterType) async {
    print('filter BLOc');
    bool exists = await File(path).exists();
    if (exists) {
      compressedImage = File(path);
    } else {
      try {
        Filter prevFilter = getComicFilter(filterType, compressedImage.path);
        await prevFilter.apply();
        compressedImage = File(path)..writeAsBytesSync(encodePng(prevFilter.output));
      } catch (e) {}
    }
    return compressedImage;
  }
}
