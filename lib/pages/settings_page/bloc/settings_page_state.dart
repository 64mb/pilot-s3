part of 'settings_page_bloc.dart';

@immutable
class SettingsPageState extends Equatable {
  const SettingsPageState({
    this.name = '',
    this.accessKey = '',
    this.secretKey = '',
    this.endpoint = '',
    this.bucket,
    this.connection,
  });

  final String name;
  final String accessKey;
  final String secretKey;
  final String endpoint;
  final String? bucket;
  final Connection? connection;

  SettingsPageState copyWith({
    String? name,
    String? accessKey,
    String? secretKey,
    String? endpoint,
    String? bucket,
    Connection? connection,
  }) {
    if (connection != null) {
      return SettingsPageState(
        name: connection.name,
        accessKey: connection.accessKey,
        secretKey: connection.secretKey,
        endpoint: connection.endpoint,
        bucket: connection.bucket,
        connection: connection,
      );
    }

    return SettingsPageState(
      name: name ?? this.name,
      accessKey: accessKey ?? this.accessKey,
      secretKey: secretKey ?? this.secretKey,
      endpoint: endpoint ?? this.endpoint,
      bucket: bucket ?? this.bucket,
      connection: connection ?? this.connection,
    );
  }

  @override
  List<Object?> get props =>
      [name, accessKey, secretKey, endpoint, bucket, connection];
}
