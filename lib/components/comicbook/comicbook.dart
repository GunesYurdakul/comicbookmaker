import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path/path.dart';
import 'package:projectX/components/dynamic-layout/dynamic-layout-item.dart';
import 'package:projectX/components/dynamic-layout/dynamic-layout.dart';
import 'dart:async';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ComicBook extends StatefulWidget {
  ComicBook({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ComicBookState createState() => _ComicBookState();
}

class _ComicBookState extends State<ComicBook>
    with SingleTickerProviderStateMixin {
  var _bottomNavIndex = 0; //default index of first screen

  AnimationController _animationController;
  Animation<double> animation;
  CurvedAnimation curve;
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

    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.5,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    Future.delayed(
      Duration(seconds: 1),
      () => _animationController.forward(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
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
          bottomNavIndex: _bottomNavIndex),
      floatingActionButton: ScaleTransition(
        scale: animation,
        child: FloatingActionButton(
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
            _animationController.reset();
            _animationController.forward();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: iconList,
          backgroundColor: HexColor('#373036'),
          activeIndex: _bottomNavIndex,
          activeColor: HexColor('#FFA400'),
          splashColor: HexColor('#FFA400'),
          inactiveColor: Colors.white,
          notchAndCornersAnimation: animation,
          splashSpeedInMilliseconds: 300,
          notchSmoothness: NotchSmoothness.defaultEdge,
          gapLocation: GapLocation.center,
          leftCornerRadius: 0,
          rightCornerRadius: 0,
          onTap: (index) {
            print('on tap' + _bottomNavIndex.toString());
            setState(() {
              print(_bottomNavIndex);
              _bottomNavIndex = index;
              if (index == 0 && currentPageIndex>0) currentPageIndex -= 1;
              else if (index == 1) currentPageIndex += 1;
            });
          }),
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
  @override
  void didUpdateWidget(ComicBookNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.iconData != widget.iconData) {
      print(oldWidget.iconData);
      print(oldWidget.iconData);
      _startAnimation();
    }
    if (oldWidget.currentPageIndex != widget.currentPageIndex) {
      setState(() {
        if (pages.length <= currentPageIndex + 1) {
          currentPageIndex += 1;
          pages.add(new DynamicLayout(
            grid:new StaggeredGridView.countBuilder(
                key:new GlobalKey(),
                crossAxisCount: 4,
                itemCount: 8,
                itemBuilder: (BuildContext context, int index) => new DynamicLayoutItem(),
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
                key:new GlobalKey(),
                crossAxisCount: 4,
                itemCount: 8,
                itemBuilder: (BuildContext context, int index) => new DynamicLayoutItem(),
                staggeredTileBuilder: (int index) =>
                    new StaggeredTile.count(2, index.isEven ? 2 : 1),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              ),
      pageNumber: 0,
    ));
    currentPageIndex = widget.currentPageIndex;
    currentPage = pages[widget.currentPageIndex];
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
    super.initState();
  }

  @override
  void didChangeDependencies() {
//    currentPage = widget.currentPage;
    super.didChangeDependencies();
  }

  _startAnimation() {
    print('start animation');
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
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
      padding: EdgeInsets.only(bottom: 100),
      color: Colors.white,
      child: Center(
        child: currentPage,
      ),
    );
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
