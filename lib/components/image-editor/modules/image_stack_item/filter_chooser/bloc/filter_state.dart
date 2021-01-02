part of 'filter_bloc.dart';

@immutable
abstract class FilterState {}

class FilterInitial extends FilterState {}
class FilterProcessed extends FilterState {
  final File filteredImage;
  FilterProcessed(this.filteredImage);
}
class FilterProcessing extends FilterState {}
