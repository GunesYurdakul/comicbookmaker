import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/filter_bloc.dart';

class FilterView extends StatefulWidget {
  final File compressedImage;
  final String path;
  final String groupValue;
  final Function(String filter) onSelected;
  final String filterType;
  const FilterView({Key key, this.onSelected, this.filterType, this.compressedImage, this.path, this.groupValue}) : super(key: key);
  @override
  _FilterViewState createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  File compressedImage;
  String path;
  String groupValue;
  @override
  void initState() {
    path = widget.path;
    groupValue = widget.groupValue;
    compressedImage = widget.compressedImage;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FilterView oldWidget) {
    setState(() {
      print(widget.groupValue + 'sele');
      groupValue = widget.groupValue;
    });
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => FilterBloc(),
        child: BlocBuilder<FilterBloc, FilterState>(buildWhen: (previousState, state) {
          if (state is FilterProcessed) {
            setState(() {
              print('processed*');
              compressedImage = state.filteredImage;
            });
            print('filter ' + state.toString());
            return true;
          } else if (state is FilterProcessing) return true;
          return false;
        }, builder: (context, state) {
          print('Filter:.' + state.toString() + (groupValue == widget.filterType).toString());
          print(groupValue + widget.filterType);
          if (state is FilterInitial) {
            FilterBloc bloc = BlocProvider.of(context);
            bloc.add(ProcessFilter(path: path, compressedImage: compressedImage, filterType: widget.filterType));
          } else if (state is FilterProcessed) {
            compressedImage = state.filteredImage;
          }
          return Container(
              padding: EdgeInsets.only(right: 5, left: 5, top: 5),
              child: GestureDetector(
                onTap: () => widget.onSelected(widget.filterType),
                child: Column(children: [
                  Container(
                    width: 75.0,
                    height: 75.0,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new FileImage(compressedImage),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                      border: new Border.all(
                        color: Colors.blue,
                        width: groupValue == widget.filterType ? 3.0 : 0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    widget.filterType,
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Woodchuck',
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  )
                ]),
              ));
        }));
  }
}
