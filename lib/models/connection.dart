import 'package:hive/hive.dart';

part 'connection.g.dart';

@HiveType(typeId: 2)
class Connection {
  @HiveField(0)
  final String endpoint;
  @HiveField(1)
  final String accessKey;
  @HiveField(2)
  final String secretKey;
  @HiveField(3)
  final String name;
  @HiveField(4)
  final String? bucket;

  Connection(
      this.name, this.endpoint, this.accessKey, this.secretKey, this.bucket);
}
