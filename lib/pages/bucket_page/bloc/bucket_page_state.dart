part of 'bucket_page_bloc.dart';

enum BucketStatus { initial, loading, success, failure }

class BucketPageState extends Equatable {
  const BucketPageState(
      {required this.items,
      this.path = const [],
      this.filter = '',
      this.status = BucketStatus.initial});

  final List<String> path;
  final String filter;
  final ListObjectsResult items;
  final BucketStatus status;

  BucketPageState copyWith(
      {ListObjectsResult? items,
      List<String>? path,
      String? filter,
      BucketStatus? status}) {
    return BucketPageState(
        items: items ?? this.items,
        path: path ?? this.path,
        filter: filter ?? this.filter,
        status: status ?? this.status);
  }

  @override
  List<Object> get props => [items, path, filter, status];
}
