part of 'edit_page_bloc.dart';

@immutable
abstract class EditPageEvent extends Equatable {
  const EditPageEvent();

  @override
  List<Object?> get props => [];
}

@immutable
class NameChanged extends EditPageEvent {
  const NameChanged({required this.name});

  final String name;

  @override
  List<Object?> get props => [name];
}

@immutable
class AccessKeyChanged extends EditPageEvent {
  const AccessKeyChanged({required this.accessKey});

  final String accessKey;

  @override
  List<Object?> get props => [accessKey];
}

@immutable
class SecretKeyChanged extends EditPageEvent {
  const SecretKeyChanged({required this.secretKey});

  final String? secretKey;

  @override
  List<Object?> get props => [secretKey];
}

@immutable
class EndpointChanged extends EditPageEvent {
  const EndpointChanged({required this.endpoint});

  final String endpoint;

  @override
  List<Object?> get props => [endpoint];
}

@immutable
class BucketChanged extends EditPageEvent {
  const BucketChanged({required this.bucket});

  final String? bucket;

  @override
  List<Object?> get props => [bucket];
}

@immutable
class SaveSubmitted extends EditPageEvent {
  const SaveSubmitted({required this.connection});

  final Connection connection;

  @override
  List<Object?> get props => [connection];
}

@immutable
class AddSubmitted extends EditPageEvent {
  const AddSubmitted();

  @override
  List<Object?> get props => [];
}

@immutable
class InitConnectionState extends EditPageEvent {
  const InitConnectionState({required this.connection});

  final Connection connection;

  @override
  List<Object?> get props => [connection];
}
