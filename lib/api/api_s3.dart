import 'dart:io';

import 'package:minio/io.dart';
import 'package:minio/minio.dart';
// ignore: library_prefixes
import 'package:minio/models.dart' as S3;

class ApiS3 {
  late Minio minio;
  late String? defaultBucket;

  ApiS3({endPoint = '', accessKey = '', secretKey = '', this.defaultBucket}) {
    minio = Minio(
        endPoint: endPoint == '' ? 'localhost' : endPoint,
        accessKey: accessKey,
        secretKey: secretKey);
  }

  update({endPoint = '', accessKey = '', secretKey = '', String? bucket}) {
    minio =
        Minio(endPoint: endPoint, accessKey: accessKey, secretKey: secretKey);
    defaultBucket = bucket;
  }

  String _getBucket(String? bucket) {
    String resultBucket = bucket ?? defaultBucket ?? '';

    if (resultBucket == '') {
      throw Exception('api-s3: bucket is empty');
    }

    return resultBucket;
  }

  Future<List<S3.Bucket>> getBuckets() async {
    List<S3.Bucket> buckets = [];

    if (defaultBucket == null || defaultBucket == '') {
      buckets.addAll(await minio.listBuckets());
    } else {
      buckets.add(S3.Bucket(DateTime.now(), defaultBucket!));
    }
    return buckets;
  }

  Future<S3.ListObjectsResult> getObjects(
      {String? bucket,
      String prefix = '',
      bool recursive = false,
      String? startAfter}) async {
    String requestBucket = _getBucket(bucket);

    String formattedPrefix = prefix == '' ? prefix : '$prefix/';
    return minio.listAllObjectsV2(requestBucket, prefix: formattedPrefix);
  }

  Future<int> getBucketsCount() async {
    List<S3.Bucket> buckets = await getBuckets();
    return buckets.length;
  }

  Future deleteObject(String objectPath, {String? bucket}) async {
    String requestBucket = _getBucket(bucket);

    return minio.removeObject(requestBucket, objectPath);
  }

  Future<String> uploadObject(String filePath, String objectPath,
      {String? bucket}) async {
    String requestBucket = _getBucket(bucket);

    File file = File(filePath);

    return minio.fPutObject(requestBucket, objectPath, file.path);
  }

  Future downloadObject(String objectPath, String filePath,
      {String? bucket}) async {
    String requestBucket = _getBucket(bucket);

    File file = File(filePath);

    return minio.fGetObject(requestBucket, objectPath, file.path);
  }
}
