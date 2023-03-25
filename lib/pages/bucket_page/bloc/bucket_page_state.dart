part of 'bucket_page_bloc.dart';

class BucketPageState extends Equatable {
  const BucketPageState({this.path = ''});

  final String path;

  BucketPageState copyWith({String? path}) {
    return BucketPageState(path: path ?? this.path);
  }

  @override
  List<Object> get props => [path];
}
