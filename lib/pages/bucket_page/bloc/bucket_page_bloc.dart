import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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
    List<String> newPath = [...state.path];
    newPath.removeLast();

    emit(state.copyWith(path: newPath));
  }

  _onFilterBucket(
    FilterBucket event,
    Emitter<BucketPageState> emit,
  ) {
    emit(state.copyWith(filter: event.filter));
  }
}
