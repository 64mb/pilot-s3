import 'package:bloc/bloc.dart';
import 'package:pilot_s3/storage.dart';
import 'package:pilot_s3/pages/settings_page/bloc/settings_page_bloc.dart';
import 'package:pilot_s3/models/connection.dart';

class ConnectionPageBloc extends SettingsPageBloc {
  ConnectionPageBloc({required Storage storage}) : super(storage: storage);
  @override
  void _onAddSubmitted(
    AddSubmitted event,
    Emitter<SettingsPageState> emit,
  ) {
    Connection connection = Connection(state.name, state.endpoint,
        state.accessKey, state.secretKey, state.bucket);
    storage.saveConnection(connection);
  }
}
