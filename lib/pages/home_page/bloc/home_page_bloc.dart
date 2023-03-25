import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:minio/minio.dart';
import 'package:minio/models.dart' hide Object;
import 'package:pilot_s3/models/connection.dart';
import 'package:pilot_s3/storage.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc({required this.storage}) : super(const HomePageState()) {
    on<SearchChanged>(_onSearchChanged);
    on<TabChanged>(_onTabChanged);
    on<SearchReset>(_onSearchReset);
    on<ConnectionsRequested>(_onConnectionsRequested);
    on<BucketsRequested>(_onBucketsRequests);
  }

  final Storage storage;

  Future<void> _onConnectionsRequested(
    ConnectionsRequested event,
    Emitter<HomePageState> emit,
  ) async {
    await emit.forEach<List<Connection>>(
      storage.getConnectionStream(),
      onData: (connections) {
        return state.copyWith(
          connections: () => connections,
        );
      },
      onError: (error, stackTrace) {
        return state;
      },
    );
  }

  void _onSearchChanged(SearchChanged event, Emitter<HomePageState> emit) {
    emit(state.copyWith(search: event.search));
  }

  void _onSearchReset(SearchReset event, Emitter<HomePageState> emit) {
    emit(state.copyWith(search: ''));
  }

  void _onTabChanged(TabChanged event, Emitter<HomePageState> emit) {
    emit(state.copyWith(tabIndex: event.tabIndex));
  }

  Future<void> _onBucketsRequests(
      BucketsRequested event, Emitter<HomePageState> emit) async {
    await emit.forEach<Map<String, List<Bucket>>>(
      storage.getBucketStream(),
      onData: (buckets) {
        return state.copyWith(
          buckets: () => buckets,
        );
      },
      onError: (error, stackTrace) {
        return state;
      },
    );
  }
}
