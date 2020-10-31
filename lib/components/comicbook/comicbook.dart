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

  int currentPageIndex = 0;
  final iconList = <IconData>[
    Icons.arrow_back,
    Icons.arrow_forward,
  ];

  @override
  void initState() {
    super.initState();
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
        title: Row(children: [
          Icon(Icons.book),
          Spacer(),
          Icon(Icons.monetization_on_rounded)
        ]),
        backgroundColor: HexColor('#373036'),
      ),
      body: ComicBookNavigation(
          changeCurrentPageIndex: (navIndex) {
            this.currentPageIndex += navIndex;
          },
          iconData: iconList[_bottomNavIndex],
          currentPageIndex: currentPageIndex,
          bottomNavIndex: _bottomNavIndex
      ),
      floatingActionButton:  FloatingActionButton(
          elevation: 8,
          backgroundColor: HexColor('#FFA400'),
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
  final _pageController = PageController(viewportFraction: 0.8);

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
          pages.add(new DynamicLayout(
            grid: new StaggeredGridView.countBuilder(
              key: new GlobalKey(),
              crossAxisCount: 4,
              itemCount: 8,
              itemBuilder: (BuildContext context, int index) =>
                  new DynamicLayoutItem(),
              staggeredTileBuilder: (int index) =>
                  new StaggeredTile.count(2, index.isEven ? 2 : 1),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            ),
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
      grid: new StaggeredGridView.countBuilder(
        key: new GlobalKey(),
        crossAxisCount: 4,
        itemCount: 8,
        itemBuilder: (BuildContext context, int index) =>
            new DynamicLayoutItem(),
        staggeredTileBuilder: (int index) =>
            new StaggeredTile.count(2, index.isEven ? 2 : 1),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
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
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Center(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Container(
              height:MediaQuery.of(context).size.height*0.8,
              child:PageView(controller: _pageController, children: pages)),
            Container(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: pages.length,
                  effect: ScrollingDotsEffect(
                    activeStrokeWidth: 2.6,
                    activeDotScale: .4,
                    radius: 8,
                    spacing: 10,
                  ),
                )),
        ]))));
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
