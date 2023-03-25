import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pilot_s3/storage.dart';
import 'package:pilot_s3/models/connection.dart';

part 'settings_page_event.dart';
part 'settings_page_state.dart';

class SettingsPageBloc extends Bloc<SettingsPageEvent, SettingsPageState> {
  SettingsPageBloc({required this.storage}) : super(const SettingsPageState()) {
    on<NameChanged>(_onNameChanged);
    on<AccessKeyChanged>(_onAccessKeyChanged);
    on<SecretKeyChanged>(_onSecretKeyChanged);
    on<EndpointChanged>(_onEndpointChanged);
    on<AddSubmitted>(_onAddSubmitted);
  }

  final Storage storage;

  void _onNameChanged(
    NameChanged event,
    Emitter<SettingsPageState> emit,
  ) {
    emit(state.copyWith(name: event.name));
  }

  void _onAccessKeyChanged(
    AccessKeyChanged event,
    Emitter<SettingsPageState> emit,
  ) {
    emit(state.copyWith(accessKey: event.accessKey));
  }

  void _onSecretKeyChanged(
    SecretKeyChanged event,
    Emitter<SettingsPageState> emit,
  ) {
    emit(state.copyWith(secretKey: event.secretKey));
  }

  void _onEndpointChanged(
    EndpointChanged event,
    Emitter<SettingsPageState> emit,
  ) {
    emit(state.copyWith(endpoint: event.endpoint));
  }

  void _onAddSubmitted(
    AddSubmitted event,
    Emitter<SettingsPageState> emit,
  ) {
    Connection connection = Connection(
        state.name, state.endpoint, state.accessKey, state.secretKey);
    storage.saveConnection(connection);
  }
}
