import 'dart:convert';
import 'package:flutter/material.dart';

class Stickers extends StatefulWidget {
  @override
  _StickersState createState() => _StickersState();
}

class _StickersState extends State<Stickers> {
  Future<List<String>> stickers;
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<String>>(
        future: _listofFiles(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.data != null) {
            return Container(
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(blurRadius: 10.9, color: Colors.grey[400])
                ]),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 250,
                      child: GridView(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  mainAxisSpacing: 0.0,
                                  maxCrossAxisExtent: 60.0),
                          children: snapshot.data.map((String path) {
                            return GridTile(
                                child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context, path);
                              },
                              child: Container(
                                child: Image(
                                    image: AssetImage(path),
                                    height: 30,
                                    width: 30),
                              ),
                            ));
                          }).toList()),
                    ),
                  ],
                ));
          } else {
            return Container();
          }
        });
  }

  Future<List<String>> _listofFiles() async {
    String manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    var manifestMap = json.decode(manifestContent);
    return manifestMap.keys
        .where((String key) => key.contains('stickers/'))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    this._listofFiles();
  }
}
