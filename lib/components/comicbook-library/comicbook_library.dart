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
        title: Text('comicsy'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
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
