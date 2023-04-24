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
      create: (context) => BucketPageBloc(),
      child: BlocBuilder<BucketPageBloc, BucketPageState>(
        buildWhen: (previous, current) {
          return previous.path != current.path ||
              previous.filter != current.filter;
        },
        builder: (context, state) {
          String currentPath = state.path.isNotEmpty
              ? '${state.path.join('/')}/'
              : state.path.join('/');
          return FutureBuilder(
            future: storage.getObjects(connection, bucket.name,
                prefix: currentPath),
            builder: (context, snapshot) {
              List<String>? directories = snapshot.data?.prefixes;
              List<Object>? objects = snapshot.data?.objects;
              List<ListTile>? directoriesWidgets = [];

              directories?.forEach(
                (directory) {
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
                      },
                    ));
                  }
                },
              );
              List<ListTile>? objectsWidgets = [];

              objects?.forEach(
                (object) {
                  String? objectName = object.key?.split('/').last;
                  if (objectName != '' &&
                      objectName != null &&
                      objectName.contains(state.filter)) {
                    objectsWidgets.add(ListTile(
                      leading: FileIcon(
                        objectName,
                        size: 22,
                      ),
                      title: Text(objectName),
                      onPressed: () async {
                        var downloadDir =
                            await path_provider.getDownloadsDirectory();
                        String? selectedDirectory = await FilePicker.platform
                            .getDirectoryPath(
                                initialDirectory: downloadDir?.path ?? '/');
                        if (selectedDirectory != null) {
                          Minio minio = Minio(
                              endPoint: connection.endpoint,
                              accessKey: connection.accessKey,
                              secretKey: connection.secretKey);

                          await minio.fGetObject(
                              bucket.name,
                              object.key!,
                              path_lib.join(selectedDirectory,
                                  path_lib.basename(object.key!)));

                          displayInfoBar(context, builder: (context, close) {
                            return InfoBar(
                              title: const Text('File downloaded'),
                              content: Text(object.key!),
                              action: IconButton(
                                icon: const Icon(FluentIcons.clear),
                                onPressed: close,
                              ),
                              severity: InfoBarSeverity.success,
                            );
                          });
                        }
                      },
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
              if (state.path.isNotEmpty) allTiles.add(backTile);
              allTiles.addAll(directoriesWidgets);
              allTiles.addAll(objectsWidgets);

              Container pathWidget = Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child:
                    Text('/$currentPath', style: const TextStyle(fontSize: 16)),
              );

              Container filterBox = Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextBox(
                  prefix: Container(
                      padding: const EdgeInsets.only(left: 12),
                      child: const Icon(FluentIcons.search)),
                  placeholder: 'Search',
                  onChanged: (value) {
                    context
                        .read<BucketPageBloc>()
                        .add(FilterBucket(filter: value));
                  },
                ),
              );

              List<Widget> allWidgets = [pathWidget, filterBox, ...allTiles];
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
