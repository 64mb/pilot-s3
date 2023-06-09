part of 'settings_page_bloc.dart';

@immutable
class SettingsPageState extends Equatable {
  const SettingsPageState(
      {this.name = '',
      this.accessKey = '',
      this.secretKey = '',
      this.endpoint = '',
      this.bucket});

  final String name;
  final String accessKey;
  final String secretKey;
  final String endpoint;
  final String? bucket;

  SettingsPageState copyWith(
      {String? name,
      String? accessKey,
      String? secretKey,
      String? endpoint,
      String? bucket}) {
    return SettingsPageState(
        name: name ?? this.name,
        accessKey: accessKey ?? this.accessKey,
        secretKey: secretKey ?? this.secretKey,
        endpoint: endpoint ?? this.endpoint,
        bucket: bucket ?? this.bucket);
  }

  @override
  List<Object?> get props => [name, accessKey, secretKey, endpoint, bucket];
}
