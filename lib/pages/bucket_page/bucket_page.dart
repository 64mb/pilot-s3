import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minio/io.dart';
import 'package:minio/minio.dart';
import 'package:minio/models.dart';
import 'package:pilot_s3/models/connection.dart';
import 'package:pilot_s3/pages/bucket_page/bloc/bucket_page_bloc.dart';
import 'package:pilot_s3/storage.dart';
import 'package:file_icon/file_icon.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path_lib;
import 'package:pilot_s3/widgets/bucket_toolbar.dart';

class StateIconCircle extends StatefulWidget {
  const StateIconCircle({super.key});
  @override
  State<StateIconCircle> createState() => _StateIconCircle();
}

class _StateIconCircle extends State<StateIconCircle> {
  Icon first_state = Icon(FluentIcons.circle_ring);
  Icon second_state = Icon(FluentIcons.circle_fill);
  Icon current_state = Icon(FluentIcons.circle_ring);
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: current_state,
        onPressed: () {},
        onTapDown: () {
          setState(() {
            if (current_state != second_state) {
              current_state = second_state;
            } else {
              current_state = first_state;
            }
          });
        });
  }
}

class BucketPage extends StatelessWidget {
  const BucketPage(
      {super.key,
      required this.bucket,
      required this.connection,
      required this.storage});

  final Storage storage;
  final Connection connection;
  final Bucket bucket;

  displayAction(BuildContext context, Text waht, Text that) => () {
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
      };

  uploadObject(state, BuildContext context) => () async {
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
          displayAction(context, const Text('File uploaded'), Text(object))();
        }
      };

  downloadObject(object, BuildContext context) => () async {
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
              context, const Text('File downloaded'), Text(object.key!))();
        }
      };

  deleteObject(object, BuildContext context, state) => () async {
        Minio minio = Minio(
            endPoint: connection.endpoint,
            accessKey: connection.accessKey,
            secretKey: connection.secretKey);

        await minio.removeObject(bucket.name, object.key!);

        if (!context.mounted) return;
        displayAction(context, const Text('File deleted'), Text(object.key!))();
        context
            .read<BucketPageBloc>()
            .add(ObjectsRequested(prefix: state.path.join('/')));
      };

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BucketPageBloc(
          storage: storage, connection: connection, bucket: bucket.name)
        ..add(const ObjectsRequested(prefix: '')),
      child: BlocBuilder<BucketPageBloc, BucketPageState>(
        buildWhen: (previous, current) {
          return previous.path != current.path ||
              previous.filter != current.filter ||
              previous.status != current.status;
        },
        builder: (context, state) {
          String currentPath = state.path.isNotEmpty
              ? '${state.path.join('/')}/'
              : state.path.join('/');

          List<String>? directories = state.items.prefixes;
          List<Object>? objects = state.items.objects;
          List<ListTile>? directoriesWidgets = [];

          for (var directory in directories) {
            List<String> splittedPrefix = directory.split('/');
            String? directoryName = splittedPrefix.length > 2
                ? splittedPrefix[splittedPrefix.length - 2]
                : splittedPrefix[0];
            List<String> newPath = [...state.path];
            newPath.add(directoryName);

            if (directoryName.contains(state.filter)) {
              directoriesWidgets.add(ListTile(
                leading: const Icon(FluentIcons.folder_horizontal),
                title: Text(directoryName.replaceAll('/', '')),
                onPressed: () {
                  context
                      .read<BucketPageBloc>()
                      .add(DirectoryAdded(path: newPath));
                  context
                      .read<BucketPageBloc>()
                      .add(ObjectsRequested(prefix: newPath.join('/')));
                },
              ));
            }
          }
          List<ListTile>? objectsWidgets = [];

          for (var object in objects) {
            String? objectName = object.key?.split('/').last;
            if (objectName != '' &&
                objectName != null &&
                objectName.contains(state.filter)) {
              objectsWidgets.add(ListTile(
                title: Text(objectName),
                leading:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const StateIconCircle(),
                  FileIcon(
                    objectName,
                    size: 22,
                  )
                ]),
                trailing:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(
                      icon: const Icon(FluentIcons.delete),
                      onPressed: () {},
                      onTapDown: deleteObject(object, context, state)),
                  const SizedBox(
                    width: 20,
                  ),
                  IconButton(
                      icon: const Icon(FluentIcons.download),
                      onPressed: () {},
                      onTapDown: downloadObject(object, context)),
                ]),
              ));
            }
          }
          List<ListTile> allTiles = [];
          ListTile backTile = ListTile(
            title: const Text('Back'),
            leading: const Icon(FluentIcons.navigate_back),
            onPressed: () {
              List<String> newPath =
                  state.path.sublist(0, state.path.length - 1);
              context.read<BucketPageBloc>().add(const ToBack());
              context
                  .read<BucketPageBloc>()
                  .add(ObjectsRequested(prefix: newPath.join('/')));
            },
          );
          if (state.path.isNotEmpty) allTiles.add(backTile);
          allTiles.addAll(directoriesWidgets);
          allTiles.addAll(objectsWidgets);

          BucketToolbar toolbar = BucketToolbar(
            path: currentPath,
            onRefresh: () {
              context
                  .read<BucketPageBloc>()
                  .add(ObjectsRequested(prefix: state.path.join('/')));
            },
            onUpload: uploadObject(state, context),
          );

          Container filterBox = Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextBox(
              prefix: Container(
                  padding: const EdgeInsets.only(left: 12),
                  child: const Icon(FluentIcons.search)),
              placeholder: 'Search',
              onChanged: (value) {
                context.read<BucketPageBloc>().add(FilterBucket(filter: value));
              },
            ),
          );

          Widget progressWidget = const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: ProgressRing(),
            ),
          );

          List<Widget> allWidgets = state.status == BucketStatus.success
              ? [toolbar, filterBox, ...allTiles]
              : [toolbar, filterBox, progressWidget];
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: allWidgets,
            ),
          );
        },
      ),
    );
  }
}
