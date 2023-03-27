part of 'bucket_page_bloc.dart';

class BucketPageState extends Equatable {
  const BucketPageState({this.path = const [], this.filter = ''});

  final List<String> path;
  final String filter;

  BucketPageState copyWith({List<String>? path, String? filter}) {
    return BucketPageState(
        path: path ?? this.path, filter: filter ?? this.filter);
  }

  @override
  List<Object> get props => [path, filter];
}
