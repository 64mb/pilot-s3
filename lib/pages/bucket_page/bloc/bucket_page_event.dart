part of 'bucket_page_bloc.dart';

abstract class BucketPageEvent extends Equatable {
  const BucketPageEvent();

  @override
  List<Object> get props => [];
}

class DirectoryAdded extends BucketPageEvent {
  const DirectoryAdded({required this.path});

  final String path;

  @override
  List<Object> get props => [path];
}

class ToBack extends BucketPageEvent {
  const ToBack();

  @override
  List<Object> get props => [];
}
