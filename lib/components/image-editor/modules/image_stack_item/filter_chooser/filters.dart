import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' hide BlendMode;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projectX/comic-filters/lib/filter.dart';
import 'package:projectX/components/image-editor/modules/image_stack_item/filter_chooser/filter_view.dart';

import 'classic_filter_view.dart';

class Filters extends StatefulWidget {
  final File image;
  final String filter;
  final Function(File image, String filter) onSelected;
  final Function(ColorFilter colorFilter) onColorFilterSelected;
  final Function() loading;
  const Filters({Key key, this.image, this.onSelected, this.filter, this.loading, this.onColorFilterSelected}) : super(key: key);
  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> with SingleTickerProviderStateMixin {
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
    'Pixelate',
    'Pixelate1',
    'Pixelate2',
  ];
  List<List<num>> classicFilters = [
    [],
    [-1, -1, -1, -1, 9, -1, -1, -1, -1],
    [-2, 1, 0, -1, 1, 1, 0, 1, 2],
    [1,1,0,1,0,-1,0,-1,-1],
    [0.272, 0.534, 0.131,
    			    0.349, 0.686, 0.168,
    			    0.393, 0.769, 0.189],
    [0.39, 0.769, 0.189, 0.0, 0.0, 0.349, 0.686, 0.168, 0.0, 0.0, 0.272, 0.534, 0.131, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0],
    [0.2126, 0.7152, 0.0722, 0.0, 0.0, 0.2126, 0.7152, 0.0722, 0.0, 0.0, 0.2126, 0.7152, 0.0722, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0],
    [0.9, 0.5, 0.1, 0.0, 0.0, 0.3, 0.8, 0.1, 0.0, 0.0, 0.2, 0.3, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0],
    [0.78, 0, 0, 0, 0, 0, 0.78, 0, 0, 0, 0, 0.78, 0, 0, 0, 0, 0, 0, 1, 0],
    [1.5, 0, 0, 0, 0, 0, 1.5, 0, 0, 0, 0, 0, 1.5, 0, 0, 0, 0, 0, 1, 0],
    [1.0, 0.0, 0.2, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0],
    [2.0, 0.0, 0.2, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 0.0, 2.0, 9.0, 2.0, 0.0, 1.0, 0.0],
    [1, 1, 1, 1, -7, 1, 1, 1, 1],
    [0.272, 0.534, 0.131,0.349, 0.686, 0.168, 0.393, 0.769, 0.189],
  ];

  //, 'PopArt1', 'PopArt2', 'PopArt3', Biliteral
  File smallImage;
  File previewImage;
  File filteredImage;
  String selected;
  String path;
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(initialIndex: 0, vsync: this, length: 2);
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
                margin: EdgeInsets.only(bottom: 70),
                height: 200,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(blurRadius: 10.9, color: Colors.grey[400])]),
                child: Column(children: [
                  Expanded(
                      flex: 1,
                      child: TabBar(controller: _tabController, tabs: [
                        Tab(
                          icon: Text(
                            'general',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Tab(
                          icon: Text(
                            'comics',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ])),
                  Divider(),
                  Expanded(
                      flex: 3,
                      child: TabBarView(controller: _tabController, children: [
                        Container(
                          child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(classicFilters.length, (index) {
                            String filter = 'BasicFilter';
                            String filterPath = '$path/$filter-${basename(widget.image.path)}-filtered.png';
                            return new FilterView(
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
                                      File outputImage = await _getFilteredImage(filterPath+index.toString(),smallImage, filter, classicFilters[index]);
                                      widget.onSelected(outputImage, val);
                                      print('image processed2');
                                    }
                                  }
                                },
                                colorFilter: classicFilters[index],
                                groupValue: selected,
                                compressedImage: previewImage,
                                filterType: filter + index.toString(),
                                path: '$path/$filter-${basename(widget.image.path)}$index-smallfiltered.png');
                          }),
                        )),
                        Container(
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
                                      File outputImage = await _getFilteredImage(filterPath, smallImage, filter);
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
                        )),
                      ]))
                ]));
          } else
            return Container(
              height: 200,
            );
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

  Future<File> _getFilteredImage(String path, File compressedImage, String filterType,[List<num> colorFilter]) async {
    bool exists = await File(path).exists();
    if (exists) {
      compressedImage = File(path);
    } else {
      try {
        ComicFilter prevFilter = getComicFilter(filterType, compressedImage.path, colorFilter);
        await prevFilter.apply();
        compressedImage = File(path)..writeAsBytesSync(encodePng(prevFilter.output));
      } catch (e) {}
    }
    return compressedImage;
  }
}
