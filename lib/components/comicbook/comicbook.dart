import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:projectX/components/dynamic-layout/dynamic-layout-item.dart';
import 'package:projectX/components/dynamic-layout/dynamic-layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ComicBook extends StatefulWidget {
  ComicBook({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ComicBookState createState() => _ComicBookState();
}

class _ComicBookState extends State<ComicBook>
    with SingleTickerProviderStateMixin {
  var _bottomNavIndex = 0; //default index of first screen
  bool readOnly;
  int currentPageIndex = 0;
  String title;
  final iconList = <IconData>[
    Icons.arrow_back,
    Icons.arrow_forward,
  ];

  @override
  void initState() {
    super.initState();
    title = widget.title;
    readOnly = true;
    currentPageIndex = 0;
    final systemTheme = SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: HexColor('#373A36'),
      systemNavigationBarIconBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(systemTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              flex:10,
              child:TextFormField(
                readOnly: readOnly,
                initialValue: 'My ComicBook',
                style: TextStyle(color: Colors.white, fontSize: 22),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefix: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  readOnly = !readOnly;
                });
              })
                ),
                onChanged: (text) {
                  title = text;
                },
          )),]),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                setState(() {
                });
              }),
        ],
        backgroundColor: Colors.red,
      ),
      body: ComicBookNavigation(
        changeCurrentPageIndex: (navIndex) {
          this.currentPageIndex += navIndex;
        },
        iconData: iconList[_bottomNavIndex],
        currentPageIndex: currentPageIndex,
        bottomNavIndex: _bottomNavIndex),
      floatingActionButton: FloatingActionButton(
        elevation: 8,
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.add,
          color: HexColor('#373A36'),
        ),
        onPressed: () {
          setState(() {
            print('NEW PAGE');
            currentPageIndex += 1;
          });
        },
      ),
    );
  }
}

class ComicBookNavigation extends StatefulWidget {
  final IconData iconData;
  final int currentPageIndex;
  final int bottomNavIndex;
  final Function(int navIndex) changeCurrentPageIndex;
  ComicBookNavigation(
      {this.iconData,
      this.currentPageIndex,
      this.bottomNavIndex,
      this.changeCurrentPageIndex})
      : super();

  @override
  _ComicBookNavigationState createState() => _ComicBookNavigationState();
}

class _ComicBookNavigationState extends State<ComicBookNavigation>
    with TickerProviderStateMixin, ChangeNotifier {
  AnimationController _controller;
  Animation<double> animation;
  int currentPageIndex;
  List<DynamicLayout> pages = List<DynamicLayout>();
  DynamicLayout currentPage;
  final _pageController = PageController(viewportFraction: 0.9);

  @override
  void didUpdateWidget(ComicBookNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.iconData != widget.iconData) {
      print(oldWidget.iconData);
      print(oldWidget.iconData);
    }
    if (oldWidget.currentPageIndex != widget.currentPageIndex) {
      setState(() {
        if (pages.length <= currentPageIndex + 1) {
          currentPageIndex += 1;
          pages.add(
            new DynamicLayout(
              pageNumber: currentPageIndex,
          ));
        }
        currentPageIndex = widget.currentPageIndex;
        currentPage = pages[widget.currentPageIndex];
      });
    }
  }

  @override
  void initState() {
    pages.add(new DynamicLayout(
      pageNumber: 0,
    ));
    currentPageIndex = widget.currentPageIndex;
    currentPage = pages[widget.currentPageIndex];
    super.initState();
  }

  @override
  void didChangeDependencies() {
//    currentPage = widget.currentPage;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild****');
    return Container(
        child: Column(
            children: [
              Expanded(
                flex:10,
                child:Container(
                  padding: EdgeInsets.only(top:MediaQuery.of(context).size.width/30),
                  width: MediaQuery.of(context).size.width,
                  height: (MediaQuery.of(context).size.width/210)*297,// A4 paper ratios
                  child: PageView(
                    controller: _pageController, 
                    children: pages))),
              Expanded(
                flex:1,
                child:Container(
                  child: SmoothPageIndicator(
                controller: _pageController,
                count: pages.length,
                effect: ScrollingDotsEffect(
                  activeStrokeWidth: 2.6,
                  activeDotScale: .4,
                  radius: 8,
                  spacing: 10,
                  )),
              )),
                    ]));
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
