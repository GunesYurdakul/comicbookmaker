import 'package:flutter/material.dart';
import 'package:projectX/components/comicbook/comicbook.dart';

class ComicBookLibrary extends StatefulWidget {
  @override
  _ComicBookLibraryState createState() => _ComicBookLibraryState();
}

class _ComicBookLibraryState extends State<ComicBookLibrary> {
  List<ComicBook> _comicBooks;
  @override
  void initState() {
    _comicBooks = List<ComicBook>();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image(image:AssetImage('assets/comicsy_logo.png'),width: MediaQuery.of(context).size.width/2,),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xff0060AA),
        onPressed: () {
          _comicBooks.add(ComicBook());
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => _comicBooks.last));
        },
      ),
      body: Container(),
    );
  }
}
