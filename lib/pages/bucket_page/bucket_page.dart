import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minio/models.dart';
import 'package:pilot_s3/models/connection.dart';
import 'package:pilot_s3/pages/bucket_page/bloc/bucket_page_bloc.dart';
import 'package:pilot_s3/storage.dart';
import 'package:file_icon/file_icon.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path_lib;
import 'package:pilot_s3/widgets/bucket_toolbar.dart';

part 'bucket_page_elements.dart';
part 'bucket_page_calls.dart';

class BucketPage extends StatelessWidget {
  const BucketPage(
      {super.key,
      required this.bucket,
      required this.connection,
      required this.storage});

  final Storage storage;
  final Connection connection;
  final Bucket bucket;

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
                subtitle: Text(
                  object.lastModified.toString().split('.')[0],
                  style: const TextStyle(
                      fontSize: 10, color: Color.fromARGB(255, 150, 150, 150)),
                ),
                trailing:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(sizeText(object.size ?? 0)),
                  const SizedBox(
                    width: 20,
                  ),
                  IconButton(
                      icon: const Icon(FluentIcons.delete),
                      onPressed: () {},
                      onTapDown: deleteObject(
                          object, connection, bucket, context, state)),
                  const SizedBox(
                    width: 20,
                  ),
                  IconButton(
                      icon: const Icon(FluentIcons.download),
                      onPressed: () {},
                      onTapDown:
                          downloadObject(object, connection, bucket, context)),
                ]),
              ));
            }
          }
          List<ListTile> allTiles = [];
          ListTile backTile = ListTile(
            title: const Text('back').tr(),
            leading: const Icon(FluentIcons.navigate_back),
            onPressed: () {
              List<String> newPath =
                  state.path.sublist(0, state.path.length - 1);
              context.read<BucketPageBloc>().add(const ToBack());
              context
                  .read<BucketPageBloc>()
                  .add(ObjectsRequested(prefix: path_lib.joinAll(newPath)));
            },
          );
          if (state.path.isNotEmpty) allTiles.add(backTile);
          allTiles.addAll(directoriesWidgets);
          allTiles.addAll(objectsWidgets);

          BucketToolbar toolbar = BucketToolbar(
            path: state.path,
            onChange: (newPath) {
              context.read<BucketPageBloc>().add(DirectoryAdded(path: newPath));
              context
                  .read<BucketPageBloc>()
                  .add(ObjectsRequested(prefix: path_lib.joinAll(newPath)));
            },
            onRefresh: () {
              context
                  .read<BucketPageBloc>()
                  .add(ObjectsRequested(prefix: path_lib.joinAll(state.path)));
            },
            onUpload: uploadObject(state, connection, bucket, context),
          );

          Container filterBox = Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextBox(
              prefix: Container(
                  padding: const EdgeInsets.only(left: 12),
                  child: const Icon(FluentIcons.search)),
              placeholder: tr('search'),
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: allWidgets,
              ),
            ),
          );
        },
      ),
    );
  }
}
