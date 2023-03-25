import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minio/models.dart';
import 'package:pilot_s3/models/connection.dart';
import 'package:pilot_s3/pages/bucket_page/bloc/bucket_page_bloc.dart';
import 'package:pilot_s3/storage.dart';
import 'package:file_icon/file_icon.dart';

class BucketPage extends StatelessWidget {
  BucketPage(
      {super.key,
      required this.bucket,
      required this.connection,
      required this.storage});

  Storage storage;
  Connection connection;
  Bucket bucket;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BucketPageBloc(),
      child: BlocBuilder<BucketPageBloc, BucketPageState>(
        buildWhen: (previous, current) {
          return previous.path != current.path;
        },
        builder: (context, state) {
          return FutureBuilder(
            future:
                storage.getObjects(connection, bucket.name, prefix: state.path),
            builder: (context, snapshot) {
              String currentPath = state.path;
              List<String>? directories = snapshot.data?.prefixes;
              List<Object>? objects = snapshot.data?.objects;

              Iterable<ListTile>? directoriesWidgets = directories?.map(
                (prefix) {
                  print(prefix);
                  List<String> splittedPrefix = prefix.split('/');
                  String? directoryName = splittedPrefix.length > 2
                      ? splittedPrefix[splittedPrefix.length - 2]
                      : splittedPrefix[0];
                  return ListTile(
                    leading: const Icon(FluentIcons.folder_horizontal),
                    title: Text(directoryName.replaceAll('/', '')),
                    onPressed: () {
                      context
                          .read<BucketPageBloc>()
                          .add(DirectoryAdded(path: prefix));
                    },
                  );
                },
              );
              List<ListTile>? objectsWidgets = [];

              objects?.forEach(
                (object) {
                  String? objectName = object.key?.split('/').last;
                  if (objectName != '') {
                    objectsWidgets.add(ListTile(
                      leading: FileIcon(
                        objectName ?? '',
                        size: 22,
                      ),
                      title: Text(objectName ?? ''),
                      onPressed: () {},
                    ));
                  }
                },
              );
              List<ListTile> allTiles = [];
              ListTile backTile = ListTile(
                title: const Text('Back'),
                leading: const Icon(FluentIcons.navigate_back),
                onPressed: () {
                  context.read<BucketPageBloc>().add(const ToBack());
                },
              );
              if (state.path != '') allTiles.add(backTile);
              if (directoriesWidgets != null) {
                allTiles.addAll(directoriesWidgets);
              }
              if (objectsWidgets != null) allTiles.addAll(objectsWidgets);

              Container pathWidget = Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child:
                    Text("/$currentPath", style: const TextStyle(fontSize: 16)),
              );

              List<Widget> allWidgets = [pathWidget, ...allTiles];
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: allWidgets,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
