import 'dart:async';
import 'dart:io';

import 'package:minio/minio.dart';
import 'package:minio/models.dart';
import 'package:pilot_s3/models/connection.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;

class Storage {
  final StreamController<List<Connection>> _controller =
      StreamController<List<Connection>>();
  final StreamController<Map<String, List<Bucket>>> _bucketController =
      StreamController<Map<String, List<Bucket>>>();
  final StreamController<List<ListObjectsResult>> _objectController =
      StreamController<List<ListObjectsResult>>();
  late Box<Connection> _box;

  Storage() {
    _init();
  }

  _init() async {
    final appDir = await path_provider.getApplicationDocumentsDirectory();
    final documentPath =
        Platform.isLinux ? path.join(appDir.path, '.config') : appDir.path;
    final folderName = Platform.isLinux ? "pilot-s3" : "PilotS3";
    final configPath = Directory(path.join(documentPath, folderName));
    if (!(await configPath.exists())) {
      configPath.create(recursive: true);
    }
    Hive.init(configPath.path);
    Hive.registerAdapter(ConnectionAdapter());
    _box = await Hive.openBox<Connection>('Connections');
    final connectionList = _box.values.toList();
    _controller.add(connectionList);
    final Map<String, List<Bucket>> buckets = await getBuckets(connectionList);
    _bucketController.add(buckets);
  }

  Stream<List<Connection>> getConnectionStream() => _controller.stream;
  Stream<Map<String, List<Bucket>>> getBucketStream() =>
      _bucketController.stream;
  Stream<List<ListObjectsResult>> getBucketObjectStream() =>
      _objectController.stream;

  void saveConnection(Connection connection) async {
    Map<dynamic, Connection> connectionMap = _box.toMap();
    final connectionKey = connectionMap.keys.firstWhere(
      (k) => connectionMap[k]?.accessKey == connection.accessKey,
      orElse: () => null,
    );

    if (connectionKey != null) {
      _box.put(connectionKey, connection);
    } else {
      _box.add(connection);
    }

    List<Connection> connectionList = _box.values.toList();
    _controller.add(connectionList);
    Map<String, List<Bucket>> buckets = await getBuckets(connectionList);
    _bucketController.add(buckets);
  }

  Future<List<Bucket>> getBucketsForConnection(Connection connection) async {
    Minio minio = Minio(
        endPoint: connection.endpoint,
        accessKey: connection.accessKey,
        secretKey: connection.secretKey);

    List<Bucket> buckets = [];

    if (connection.bucket == null) {
      buckets.addAll(await minio.listBuckets());
    } else {
      buckets.add(Bucket(DateTime.now(), connection.bucket!));
    }
    return buckets;
  }

  Future<Map<String, List<Bucket>>> getBuckets(
      List<Connection> connections) async {
    Map<String, List<Bucket>> bucketsMap = {};

    for (Connection connection in connections) {
      bucketsMap[connection.accessKey] =
          await getBucketsForConnection(connection);
    }
    return bucketsMap;
  }

  void deleteConnection(Connection connection) {
    Map<dynamic, Connection> connectionMap = _box.toMap();
    final connectionKey = connectionMap.keys.firstWhere(
      (k) => connectionMap[k]?.accessKey == connection.accessKey,
      orElse: () => null,
    );
    _box.delete(connectionKey);
    List<Connection> connectionList = _box.values.toList();
    _controller.add(connectionList);
  }

  Future<ListObjectsResult> getObjects(Connection connection, String bucket,
      {String prefix = '', bool recursive = false, String? startAfter}) async {
    Minio minio = Minio(
        endPoint: connection.endpoint,
        accessKey: connection.accessKey,
        secretKey: connection.secretKey);
    return await minio.listAllObjectsV2(bucket, prefix: prefix);
  }
}
