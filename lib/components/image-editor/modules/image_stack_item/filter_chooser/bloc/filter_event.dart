part of 'filter_bloc.dart';

@immutable
abstract class FilterEvent {
  const FilterEvent();
}

class ProcessFilter extends FilterEvent {
  final String filterType;
  final String path;
  final File compressedImage;

  const ProcessFilter({
    @required this.path,
    @required this.compressedImage,
    @required this.filterType,
  });

  @override
  List<Object> get props => [path, compressedImage, filterType];

}