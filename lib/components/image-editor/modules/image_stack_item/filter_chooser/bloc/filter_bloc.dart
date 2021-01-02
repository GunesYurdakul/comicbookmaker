import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image/image.dart';
import 'package:meta/meta.dart';
import 'package:projectX/comic-filters/lib/filter.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(FilterInitial());

  @override
  Stream<FilterState> mapEventToState(
    FilterEvent event,
  ) async* {
    print('filter bloc map' + event.toString());
    if (event is ProcessFilter) {
      yield FilterProcessing();
      File filteredImage = await _getPreviewImage(event.path, event.compressedImage, event.filterType);
      yield FilterProcessed(filteredImage);
    }
    // TODO: implement mapEventToState
  }

  Future<File> _getPreviewImage(String path, File compressedImage, String filterType) async {
    print('filter BLOc');
    bool exists = await File(path).exists();
    if (exists) {
      compressedImage = File(path);
    }
    else{
      try{
        Filter prevFilter = getComicFilter(filterType, compressedImage.path);
        await prevFilter.apply();
        compressedImage = File(path)..writeAsBytesSync(encodePng(prevFilter.output));
      }catch(e){

      }
    }
    return compressedImage;
  }
}
