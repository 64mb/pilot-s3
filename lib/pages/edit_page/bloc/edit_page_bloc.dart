import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pilot_s3/storage.dart';
import 'package:pilot_s3/models/connection.dart';

part 'edit_page_event.dart';
part 'edit_page_state.dart';

class EditPageBloc extends Bloc<EditPageEvent, EditPageState> {
  EditPageBloc(Connection connection, {required this.storage})
      : super(EditPageState.connection(connection)) {
    on<NameChanged>(_onNameChanged);
    on<AccessKeyChanged>(_onAccessKeyChanged);
    on<SecretKeyChanged>(_onSecretKeyChanged);
    on<BucketChanged>(_onBucketChanged);
    on<EndpointChanged>(_onEndpointChanged);
    on<AddSubmitted>(_onAddSubmitted);
    on<SaveSubmitted>(_onSaveSubmitted);
  }

  final Storage storage;

  void _onNameChanged(
    NameChanged event,
    Emitter<EditPageState> emit,
  ) {
    emit(state.copyWith(name: event.name));
  }

  void _onAccessKeyChanged(
    AccessKeyChanged event,
    Emitter<EditPageState> emit,
  ) {
    emit(state.copyWith(accessKey: event.accessKey));
  }

  void _onSecretKeyChanged(
    SecretKeyChanged event,
    Emitter<EditPageState> emit,
  ) {
    emit(state.copyWith(secretKey: event.secretKey));
  }

  void _onBucketChanged(
    BucketChanged event,
    Emitter<EditPageState> emit,
  ) {
    emit(state.copyWith(bucket: event.bucket));
  }

  void _onEndpointChanged(
    EndpointChanged event,
    Emitter<EditPageState> emit,
  ) {
    emit(state.copyWith(endpoint: event.endpoint));
  }

  void _onAddSubmitted(
    AddSubmitted event,
    Emitter<EditPageState> emit,
  ) {
    storage.saveConnection(
        null,
        Connection(
            name: state.name,
            endpoint: state.endpoint,
            accessKey: state.accessKey,
            secretKey: state.secretKey,
            bucket: state.bucket));
  }

  void _onSaveSubmitted(
    SaveSubmitted event,
    Emitter<EditPageState> emit,
  ) {
    storage.saveConnection(
        event.connection,
        Connection(
            name: state.name,
            endpoint: state.endpoint,
            accessKey: state.accessKey,
            secretKey: state.secretKey,
            bucket: state.bucket));
  }
}
