import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:minio/models.dart' hide Object;
import 'package:pilot_s3/models/connection.dart';
import 'package:pilot_s3/storage.dart';

part 'bucket_page_event.dart';
part 'bucket_page_state.dart';

class BucketPageBloc extends Bloc<BucketPageEvent, BucketPageState> {
  BucketPageBloc(
      {required this.storage, required this.connection, required this.bucket})
      : super(BucketPageState(
            items: ListObjectsResult(objects: [], prefixes: []))) {
    on<DirectoryAdded>(_onDirectoryAdded);
    on<ToBack>(_onToBack);
    on<FilterBucket>(_onFilterBucket);
    on<ChangeStatus>(_onChangeStatus);
    on<ObjectsRequested>(_onObjectRequested);
  }

  final Storage storage;
  final String bucket;
  final Connection connection;

  _onDirectoryAdded(
    DirectoryAdded event,
    Emitter<BucketPageState> emit,
  ) {
    emit(state.copyWith(path: event.path, status: BucketStatus.loading));
  }

  _onToBack(
    ToBack event,
    Emitter<BucketPageState> emit,
  ) {
    List<String> newPath = state.path.sublist(0, state.path.length - 1);

    emit(state.copyWith(path: newPath, status: BucketStatus.loading));
  }

  _onFilterBucket(
    FilterBucket event,
    Emitter<BucketPageState> emit,
  ) {
    emit(state.copyWith(filter: event.filter));
  }

  _onObjectRequested(
    ObjectsRequested event,
    Emitter<BucketPageState> emit,
  ) async {
    emit(state.copyWith(status: BucketStatus.loading));

    ListObjectsResult objects =
        await storage.getObjects(connection, bucket, prefix: event.prefix);

    emit(state.copyWith(status: BucketStatus.success, items: objects));
  }

  _onChangeStatus(
    ChangeStatus event,
    Emitter<BucketPageState> emit,
  ) {
    emit(state.copyWith(status: event.status));
  }
}
