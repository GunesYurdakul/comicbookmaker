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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image(
          image: AssetImage('assets/logosimple.png'),
          width: MediaQuery.of(context).size.width / 3,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _comicBooks.add(Post());
          Navigator.push(context, MaterialPageRoute(builder: (context) => _comicBooks.last));
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  getPostOption('Post'),
                  getPostOption('Grid'),
                ],
              ),
            ),
            Divider(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  getThemaGroup('Love'),
                  getThemaGroup('Brand Promotion'),
                  getThemaGroup('Birthday'),
                  getThemaGroup('Give Away'),
                  getThemaGroup('Meme'),
                  getThemaGroup('Comic Book Page'),
                  getThemaGroup('Comic Book Cover'),
                ],
              ),
            ),
      ])),
    );
  }

  Widget getPostOption(title) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5)
      ),
      child: InkWell(
        onTap: () {
          _comicBooks.add(Post());
          Navigator.push(context, MaterialPageRoute(builder: (context) => _comicBooks.last));
        },
        child: Center(
          child: Text(title))
      )
    );
  }
  Widget getThemaGroup(title) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5)
      ),
      child: Center(
        child: Text(title)
      )
    );
  }
}
