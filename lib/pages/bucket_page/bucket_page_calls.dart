part of 'bucket_page.dart';

List<String> list = ['b', 'Kb', 'Mb', 'Gb', 'Tb', 'Pb', 'Eb', 'Zb', 'Yb', 'Bb'];
String sizeText(int size) {
  int count = 0;
  while (size > 2024) {
    size = (size / 1024).round();
    ++count;
  }
  String name = list[count];
  return '$size $name';
}

displayAction(BuildContext context, Text what, Text that) {
  displayInfoBar(context, builder: (context, close) {
    return InfoBar(
      title: what,
      content: that,
      action: IconButton(
        icon: const Icon(FluentIcons.clear),
        onPressed: close,
      ),
      severity: InfoBarSeverity.success,
    );
  });
}

displayProgressBar(BuildContext context) {
  displayInfoBar(context, duration: const Duration(seconds: 10),
      builder: (context, close) {
    return Transform.scale(scale: 3, child: const ProgressBar());
  });
}

deleteObject(object, connection, bucket, BuildContext context, state) =>
    () async {
      Minio minio = Minio(
          endPoint: connection.endpoint,
          accessKey: connection.accessKey,
          secretKey: connection.secretKey);

      await minio.removeObject(bucket.name, object.key!);

      if (context.mounted) {
        displayAction(context, const Text('file_deleted').tr(), Text(object.key!));
        context
            .read<BucketPageBloc>()
            .add(ObjectsRequested(prefix: state.path.join('/')));
      }
    };

uploadObject(state, connection, bucket, BuildContext context) => () async {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        if (context.mounted) {
          displayProgressBar(context);
        }
        File file = File(result.files.single.path!);
        Minio minio = Minio(
            endPoint: connection.endpoint,
            accessKey: connection.accessKey,
            secretKey: connection.secretKey);

        String fileName = result.files.single.name;
        String path = state.path.join('/');

        String object = state.path.isNotEmpty ? '$path/$fileName' : fileName;

        await minio.fPutObject(bucket.name, object, file.path);
        if (context.mounted) {
          context.read<BucketPageBloc>().add(ObjectsRequested(prefix: path));
          displayAction(context, const Text('file_uploaded').tr(), Text(fileName));
        }
      }
    };

downloadObject(object, connection, bucket, BuildContext context) => () async {
      var downloadDir = await path_provider.getDownloadsDirectory();
      String? selectedDirectory = await FilePicker.platform
          .getDirectoryPath(initialDirectory: downloadDir?.path ?? '/');
      if (selectedDirectory != null) {
        Minio minio = Minio(
            endPoint: connection.endpoint,
            accessKey: connection.accessKey,
            secretKey: connection.secretKey);

        await minio.fGetObject(bucket.name, object.key!,
            path_lib.join(selectedDirectory, path_lib.basename(object.key!)));

        if (context.mounted) {
          displayAction(
              context, const Text('file_downloaded').tr(), Text(object.key!));
        }
      }
    };
