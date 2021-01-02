import 'dart:convert';
import 'package:flutter/material.dart';

class ImageMenuBottomSheet extends StatefulWidget {
  final String pathKey;

  const ImageMenuBottomSheet({Key key, this.pathKey}) : super(key: key);
  @override
  _ImageMenuBottomSheetState createState() => _ImageMenuBottomSheetState();
}

class _ImageMenuBottomSheetState extends State<ImageMenuBottomSheet> with SingleTickerProviderStateMixin {
  String pathKey;

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<Map<String, List<String>>>(
        future: _listofFiles(),
        builder: (BuildContext context, AsyncSnapshot<Map<String, List<String>>> snapshot) {
          if (snapshot.data != null) {
            TabController _tabController = TabController(initialIndex: 0, vsync: this, length: snapshot.data.length);
            return Material(
                color: Colors.transparent,
                child: Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(blurRadius: 10.9, color: Colors.grey[400])]),
                    child: Column(children: [
                      Expanded(
                          flex: 1,
                          child: TabBar(
                            controller: _tabController,
                            tabs: snapshot.data.keys
                                .map((e) => Tab(
                                      icon: Text(
                                        e,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ))
                                .toList(),
                          )),
                      Divider(),
                      Expanded(
                          flex: 5,
                          child: TabBarView(
                              controller: _tabController,
                              children: snapshot.data.values
                                  .map((stickerGroup) => Container(
                                        height: 250,
                                        child: GridView(
                                            padding: EdgeInsets.all(15),
                                            shrinkWrap: true,
                                            physics: ClampingScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(mainAxisSpacing: 0.0, maxCrossAxisExtent: 60.0),
                                            children: stickerGroup.map((String path) {
                                              return GridTile(
                                                  child: GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context, path);
                                                },
                                                child: Container(
                                                  child: Image(image: AssetImage(path), height: 30, width: 30),
                                                ),
                                              ));
                                            }).toList()),
                                      ))
                                  .toList()))
                    ])));
          } else {
            return Container();
          }
        });
  }

  Future<Map<String, List<String>>> _listofFiles() async {
    Map<String, List<String>> imagesInFolders = Map<String, List<String>>();
    String manifestContent = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    var manifestMap = json.decode(manifestContent);
    for (var i = 1; i <= 4; i++) {
      imagesInFolders[i.toString()] = manifestMap.keys.where((String key) => (key.contains('$pathKey/$i') && !key.contains('DS_Store'))).toList();
      print(imagesInFolders[i.toString()].length);
    }
    return imagesInFolders;
  }

  @override
  void initState() {
    pathKey = widget.pathKey;
    super.initState();
    this._listofFiles();
  }
}
