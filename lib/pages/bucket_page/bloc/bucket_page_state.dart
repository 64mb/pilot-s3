part of 'bucket_page_bloc.dart';

class BucketPageState extends Equatable {
  const BucketPageState({this.path = '', this.filter = ''});

  final String path;
  final String filter;

  BucketPageState copyWith({String? path, String? filter}) {
    return BucketPageState(
        path: path ?? this.path, filter: filter ?? this.filter);
  }

  @override
  List<Object> get props => [path, filter];
}
