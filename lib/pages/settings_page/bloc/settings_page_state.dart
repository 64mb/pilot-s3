part of 'settings_page_bloc.dart';

@immutable
class SettingsPageState extends Equatable {
  const SettingsPageState(
      {this.name = '',
      this.accessKey = '',
      this.secretKey = '',
      this.endpoint = ''});

  final String name;
  final String accessKey;
  final String secretKey;
  final String endpoint;

  SettingsPageState copyWith({
    String? name,
    String? accessKey,
    String? secretKey,
    String? endpoint,
  }) {
    return SettingsPageState(
      name: name ?? this.name,
      accessKey: accessKey ?? this.accessKey,
      secretKey: secretKey ?? this.secretKey,
      endpoint: endpoint ?? this.endpoint,
    );
  }

  @override
  List<Object?> get props => [name, accessKey, secretKey, endpoint];
}
