import 'package:projectX/components/dynamic-layout/dynamic-layout-item.dart';
import 'package:projectX/components/image/image-item.dart';

class ComicBookSingleton {
  static final ComicBookSingleton _singleton = ComicBookSingleton._internal();
  Map<int, ImageItem> comicBookImages;
  factory ComicBookSingleton() {
    return _singleton;
  }
  
  ComicBookSingleton._internal();
}
