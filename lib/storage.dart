import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
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

  Box<Connection>? _box;

  Storage() {
    _init();
  }

  _init() async {
    String? hiveDbPath;

    if (!kIsWeb) {
      final appDir = await path_provider.getApplicationDocumentsDirectory();
      final documentPath =
          Platform.isLinux ? path.join(appDir.path, '.config') : appDir.path;
      final folderName = Platform.isLinux ? 'pilot-s3' : 'PilotS3';
      final configPath = Directory(path.join(documentPath, folderName));
      if (!(await configPath.exists())) {
        configPath.create(recursive: true);
      }
      hiveDbPath = configPath.path;
    }

    Hive.init(hiveDbPath);
    Hive.registerAdapter(ConnectionAdapter());
    _box = await Hive.openBox<Connection>('Connections');

    if (_box != null) {
      final connectionList = _box!.values.toList();
      _controller.add(connectionList);
      final Map<String, List<Bucket>> buckets =
          await getBuckets(connectionList);
      _bucketController.add(buckets);
    }
  }

  Stream<List<Connection>> getConnectionStream() => _controller.stream;
  Stream<Map<String, List<Bucket>>> getBucketStream() =>
      _bucketController.stream;

  void saveConnection(Connection? prevConnection, Connection connection) async {
    if (_box == null) return;
    final String accessKey = prevConnection != null
        ? prevConnection.accessKey
        : connection.accessKey;
    Map<dynamic, Connection> connectionMap = _box!.toMap();
    final connectionKey = connectionMap.keys.firstWhere(
      (k) => connectionMap[k]?.accessKey == accessKey,
      orElse: () => null,
    );

    if (connectionKey != null) {
      _box!.put(connectionKey, connection);
    } else {
      _box!.add(connection);
    }
    _box!.compact();

    List<Connection> connectionList = _box!.values.toList();
    _controller.add(connectionList);
    Map<String, List<Bucket>> buckets = await getBuckets(connectionList);
    _bucketController.add(buckets);
  }

  Future<Map<String, List<Bucket>>> getBuckets(
      List<Connection> connections) async {
    Map<String, List<Bucket>> bucketsMap = {};

    for (Connection connection in connections) {
      bucketsMap[connection.accessKey] = await connection.getBuckets();
    }
    return bucketsMap;
  }

  void deleteConnection(Connection connection) {
    if (_box == null) return;
    Map<dynamic, Connection> connectionMap = _box!.toMap();
    final connectionKey = connectionMap.keys.firstWhere(
      (k) => connectionMap[k]?.accessKey == connection.accessKey,
      orElse: () => null,
    );
    if (connectionKey == null) return;
    _box!.delete(connectionKey);
    _box!.compact();
    List<Connection> connectionList = _box!.values.toList();
    _controller.add(connectionList);
  }

  void editConnection(Connection connection) {}

  Future<ListObjectsResult> getObjects(Connection connection, String bucket,
      {String prefix = '', bool recursive = false, String? startAfter}) async {
    var result = connection.getObjects(
        bucket: bucket,
        prefix: prefix,
        recursive: recursive,
        startAfter: startAfter);
    return result;
  }

  int getConnectionCount() {
    if (_box == null) return 0;
    return _box!.values.toList().length;
  }

  Future<int> getBucketCount() async {
    int count = 0;
    if (_box == null) return count;
    List<Connection> connections = _box!.values.toList();

    List<int> bucketsCountSeed =
        await Future.wait(connections.map((conn) => conn.getBucketsCount()));

    count = bucketsCountSeed.sum;
    return count;
  }

  Future<Map<String, int>> getDashboardStatistic() async {
    Map<String, int> statistic = {};
    statistic['connections'] = getConnectionCount();
    statistic['buckets'] = await getBucketCount();

    return statistic;
  }
}
