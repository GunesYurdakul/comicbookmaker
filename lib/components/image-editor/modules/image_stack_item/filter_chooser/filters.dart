import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:projectX/components/image-editor/modules/image_stack_item/filter_chooser/filter_view.dart';

class Filters extends StatefulWidget {
  final image;
  final Function(File image) onSelected;
  const Filters({Key key, this.image, this.onSelected}) : super(key: key);
  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  Future<List<String>> filters;
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<String>>(
        future: _listofFiles(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.only(bottom: 90, left: 12, right: 12),
              height: 100,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    5,
                    (index) => GestureDetector(
                        onTap: () {
                          print(index);
                        },
                        child: FilterView()),
                  )));
        });
  }

  Future<List<String>> _listofFiles() async {
    String manifestContent = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    var manifestMap = json.decode(manifestContent);
    return manifestMap.keys.where((String key) => key.contains('stickers/')).toList();
  }

  @override
  void initState() {
    super.initState();
    this._listofFiles();
  }
}
