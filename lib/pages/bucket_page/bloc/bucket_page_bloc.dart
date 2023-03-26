import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:minio/models.dart' hide Object;
import 'package:pilot_s3/models/connection.dart';
import 'package:pilot_s3/storage.dart';

part 'bucket_page_event.dart';
part 'bucket_page_state.dart';

class BucketPageBloc extends Bloc<BucketPageEvent, BucketPageState> {
  BucketPageBloc() : super(const BucketPageState()) {
    on<DirectoryAdded>(_onDirectoryAdded);
    on<ToBack>(_onToBack);
    on<FilterBucket>(_onFilterBucket);
  }

  _onDirectoryAdded(
    DirectoryAdded event,
    Emitter<BucketPageState> emit,
  ) {
    emit(state.copyWith(path: event.path));
  }

  _onToBack(
    ToBack event,
    Emitter<BucketPageState> emit,
  ) {
    List<String> splittedPath = state.path.split('/');
    String lastDirectory = splittedPath.elementAt(splittedPath.length - 2);

    String newPath = state.path.replaceAll("$lastDirectory/", '');

    emit(state.copyWith(path: newPath));
  }

  _onFilterBucket(
    FilterBucket event,
    Emitter<BucketPageState> emit,
  ) {
    emit(state.copyWith(filter: event.filter));
  }
}
