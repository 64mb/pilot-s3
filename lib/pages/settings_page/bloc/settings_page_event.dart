part of 'settings_page_bloc.dart';

@immutable
abstract class SettingsPageEvent extends Equatable {
  const SettingsPageEvent();

  @override
  List<Object?> get props => [];
}

@immutable
class NameChanged extends SettingsPageEvent {
  const NameChanged({required this.name});

  final String name;

  @override
  List<Object?> get props => [name];
}

@immutable
class AccessKeyChanged extends SettingsPageEvent {
  const AccessKeyChanged({required this.accessKey});

  final String accessKey;

  @override
  List<Object?> get props => [accessKey];
}

@immutable
class SecretKeyChanged extends SettingsPageEvent {
  const SecretKeyChanged({required this.secretKey});

  final String? secretKey;

  @override
  List<Object?> get props => [secretKey];
}

@immutable
class EndpointChanged extends SettingsPageEvent {
  const EndpointChanged({required this.endpoint});

  final String endpoint;

  @override
  List<Object?> get props => [endpoint];
}

@immutable
class BucketChanged extends SettingsPageEvent {
  const BucketChanged({required this.bucket});

  final String? bucket;

  @override
  List<Object?> get props => [bucket];
}

@immutable
class AddSubmitted extends SettingsPageEvent {
  const AddSubmitted();

  @override
  List<Object?> get props => [];
}

@immutable
class ConnectionChanged extends SettingsPageEvent {
  const ConnectionChanged({required this.connection});

  final Connection connection;

  @override
  List<Object?> get props => [connection];
}
