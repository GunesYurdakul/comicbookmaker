import 'package:flutter/material.dart';
import 'package:projectX/components/post/post.dart';

class ComicBookLibrary extends StatefulWidget {
  @override
  _ComicBookLibraryState createState() => _ComicBookLibraryState();
}

class _ComicBookLibraryState extends State<ComicBookLibrary> {
  List<Post> _comicBooks;
  @override
  void initState() {
    _comicBooks = List<Post>();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image(image:AssetImage('assets/comicsy_logo.png'),width: MediaQuery.of(context).size.width/3,),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xff0060AA),
        onPressed: () {
          _comicBooks.add(Post());
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => _comicBooks.last));
        },
      ),
      body: Container(),
    );
  }
}
