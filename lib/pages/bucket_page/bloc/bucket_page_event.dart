part of 'bucket_page_bloc.dart';

abstract class BucketPageEvent extends Equatable {
  const BucketPageEvent();

  @override
  List<Object> get props => [];
}

class DirectoryAdded extends BucketPageEvent {
  const DirectoryAdded({required this.path});

  final List<String> path;

  @override
  List<Object> get props => [path];
}

class ToBack extends BucketPageEvent {
  const ToBack();

  @override
  List<Object> get props => [];
}

class FilterBucket extends BucketPageEvent {
  const FilterBucket({required this.filter});

  final String filter;

  @override
  List<Object> get props => [filter];
}

class ChangeStatus extends BucketPageEvent {
  const ChangeStatus({required this.status});

  final BucketStatus status;

  @override
  List<Object> get props => [status];
}

class ObjectsRequested extends BucketPageEvent {
  const ObjectsRequested({required this.prefix});

  final String prefix;

  @override
  List<Object> get props => [prefix];
}
