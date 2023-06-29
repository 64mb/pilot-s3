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

deleteObject(
        object, Connection connection, bucket, BuildContext context, state) =>
    () async {
      await connection.deleteObject(object.key!, bucket: bucket.name);

      if (context.mounted) {
        displayAction(
            context, const Text('file_deleted').tr(), Text(object.key!));
        context
            .read<BucketPageBloc>()
            .add(ObjectsRequested(prefix: path_lib.joinAll(state.path)));
      }
    };

uploadObject(state, Connection connection, bucket, BuildContext context) =>
    () async {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        if (context.mounted) {
          displayProgressBar(context);
        }
        File file = File(result.files.single.path!);

        String fileName = result.files.single.name;
        String newPath = path_lib.joinAll(state.path);

        String object = state.path.isNotEmpty ? '$newPath/$fileName' : fileName;

        await connection.uploadObject(file.path, object, bucket: bucket.name);
        if (context.mounted) {
          context.read<BucketPageBloc>().add(ObjectsRequested(prefix: newPath));
          displayAction(
              context, const Text('file_uploaded').tr(), Text(fileName));
        }
      }
    };

downloadObject(object, Connection connection, bucket, BuildContext context) =>
    () async {
      var downloadDir = await path_provider.getDownloadsDirectory();
      String? selectedDirectory = await FilePicker.platform
          .getDirectoryPath(initialDirectory: downloadDir?.path ?? '/');
      if (selectedDirectory != null) {
        await connection.downloadObject(object.key!,
            path_lib.join(selectedDirectory, path_lib.basename(object.key!)),
            bucket: bucket.name);

        if (context.mounted) {
          displayAction(
              context, const Text('file_downloaded').tr(), Text(object.key!));
        }
      }
    };
