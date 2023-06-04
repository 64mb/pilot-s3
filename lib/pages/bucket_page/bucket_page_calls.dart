part of 'bucket_page.dart';

displayAction(BuildContext context, Text waht, Text that) {
  displayInfoBar(context, builder: (context, close) {
    return InfoBar(
      title: waht,
      content: that,
      action: IconButton(
        icon: const Icon(FluentIcons.clear),
        onPressed: close,
      ),
      severity: InfoBarSeverity.success,
    );
  });
}

deleteObject(object, connection, bucket, BuildContext context, state) =>
    () async {
      Minio minio = Minio(
          endPoint: connection.endpoint,
          accessKey: connection.accessKey,
          secretKey: connection.secretKey);

      await minio.removeObject(bucket.name, object.key!);

      if (!context.mounted) return;
      displayAction(context, const Text('File deleted'), Text(object.key!));
      context
          .read<BucketPageBloc>()
          .add(ObjectsRequested(prefix: state.path.join('/')));
    };

uploadObject(state, connection, bucket, BuildContext context) => () async {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        File file = File(result.files.single.path!);
        Minio minio = Minio(
            endPoint: connection.endpoint,
            accessKey: connection.accessKey,
            secretKey: connection.secretKey);

        String fileName = result.files.single.name;
        String path = state.path.join('/');

        String object = state.path.isNotEmpty ? '$path/$fileName' : fileName;

        await minio.fPutObject(bucket.name, object, file.path);
        if (!context.mounted) return;
        context.read<BucketPageBloc>().add(ObjectsRequested(prefix: path));
        displayAction(context, const Text('File uploaded'), Text(fileName));
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

        if (!context.mounted) return;
        displayAction(
            context, const Text('File downloaded'), Text(object.key!));
      }
    };
