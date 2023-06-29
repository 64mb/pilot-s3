import 'dart:math';
import 'dart:io';
import 'package:test/test.dart';
import 'package:pilot_s3/api/api_s3.dart';
import 'package:crypto/crypto.dart' as crypto;

String generateRandomString(int len) {
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}

void main() {
  String bucketName = Platform.environment['TEST_S3_BUCKET'] ?? '';

  ApiS3 api = ApiS3(
      endPoint: Platform.environment['TEST_S3_ENDPOINT'] ?? '',
      accessKey: Platform.environment['TEST_S3_ACCESS_KEY'] ?? '',
      secretKey: Platform.environment['TEST_S3_SECRET_KEY'] ?? '',
      defaultBucket: bucketName);

  var objectPath = 'test${generateRandomString(10)}.txt';
  var filePath = 'test/$objectPath';
  objectPath = 'test/$objectPath';
  var filePathCheck = '$filePath.check';

  var file = File(filePath);
  var fileCheck = File(filePathCheck);

  setUp(() async {
    // TODO: up docker minio s3
  });

  tearDown(() async {
    if (await file.exists()) {
      await file.delete();
    }
    if (await fileCheck.exists()) {
      await fileCheck.delete();
    }
  });

  group('api: s3', () {
    test('get buckets', () async {
      var buckets = await api.getBuckets();

      expect(buckets.length, equals(1), reason: 'buckets list not empty');
      expect(buckets[0].name, equals(bucketName),
          reason: 'bucket with current name exist');
    });

    test('get buckets count', () async {
      var bucketsCount = await api.getBucketsCount();

      expect(bucketsCount, equals(1), reason: 'buckets count not zero');
    });

    test('get buckets count', () async {
      var bucketsCount = await api.getBucketsCount();

      expect(bucketsCount, equals(1), reason: 'bucket exist');
    });

    test('upload - download - delete object', () async {
      await api.deleteObject(objectPath);

      var objects = await api.getObjects();
      var findObject =
          objects.objects.where((element) => element.key == objectPath);
      expect(findObject.length, equals(0), reason: 'object not found');

      var seedFile = generateRandomString(1024 * 512 * 1); // 512KB

      if (await file.exists()) {
        await file.delete();
      }
      await file.writeAsString(seedFile);

      var md5 = (await crypto.md5.bind(file.openRead()).first).toString();

      await api.uploadObject(filePath, objectPath);

      objects = await api.getObjects();
      findObject =
          objects.objects.where((element) => element.key == objectPath);

      expect(findObject.length, equals(1), reason: 'object found after upload');

      await api.downloadObject(objectPath, filePathCheck);

      var md5Check = (await crypto.md5.bind(file.openRead()).first).toString();

      expect(md5, equals(md5Check),
          reason: 'md5 sum of download and upload files the same');

      await api.deleteObject(objectPath);

      objects = await api.getObjects();
      findObject =
          objects.objects.where((element) => element.key == objectPath);

      expect(findObject.length, equals(0),
          reason: 'object not found after delete');
    }, timeout: const Timeout(Duration(minutes: 2)));
  });
}
