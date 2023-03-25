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
class AddSubmitted extends SettingsPageEvent {
  const AddSubmitted();

  @override
  List<Object?> get props => [];
}
