import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minio/models.dart';
import 'package:pilot_s3/models/connection.dart';
import 'package:pilot_s3/pages/home_page/bloc/home_page_bloc.dart';
import 'package:pilot_s3/pages/edit_page/edit_page.dart';
import 'package:pilot_s3/pages/bucket_page/bucket_page.dart';
import 'package:pilot_s3/pages/settings_page.dart';
import 'package:pilot_s3/storage.dart';
import 'package:pilot_s3/widgets/home_dashboard.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.storage});

  final Storage storage;

  List<NavigationPaneItem> getConnectionItems(
      List<Connection> connections, Map<String, List<Bucket>> buckets) {
    List<NavigationPaneItem> items = [
      PaneItemHeader(header: const Text('connections').tr()),
      PaneItemSeparator(),
    ];

    for (Connection connection in connections) {
      List<PaneItem> bucketItems = [];
      if (buckets[connection.accessKey] != null) {
        bucketItems = buckets[connection.accessKey]!.map((bucket) {
          return PaneItem(
              body: BucketPage(
                  connection: connection, bucket: bucket, storage: storage),
              title: Text(bucket.name),
              icon: const Icon(FluentIcons.outlook_spaces_bucket));
        }).toList();
      }
      items.add(PaneItemExpander(
          title: Text(connection.name),
          body: EditPage(
            connection: connection,
            edit: true,
            storage: storage,
          ),
          items: bucketItems,
          icon: const Icon(FluentIcons.data_connection_library)));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final searchFocusNode = FocusNode();
    final searchController = TextEditingController();
    final key = GlobalKey();

    return BlocProvider(
      create: (context) => HomePageBloc(storage: context.read<Storage>())
        ..add(const ConnectionsRequested())
        ..add(const BucketsRequested()),
      child: BlocBuilder<HomePageBloc, HomePageState>(
        builder: (context, state) {
          final List<NavigationPaneItem> originalItems = [
            PaneItemHeader(header: const Text('menu').tr()),
            PaneItemSeparator(),
            PaneItem(
              icon: const Icon(FluentIcons.home),
              title: const Text('home').tr(),
              body: HomeDashboard(
                storage: storage,
              ),
            ),
          ];

          final List<Connection> connections = state.connections;
          final Map<String, List<Bucket>> buckets = state.buckets;

          List<NavigationPaneItem> connectionItems =
              getConnectionItems(connections, buckets);

          List<PaneItem> flatConnectionItems = [];
          List<PaneItem> flatBucketItems = [];
          for (var connection in connections) {
            flatConnectionItems.add(PaneItem(
                title: Text(connection.name),
                body: EditPage(
                  connection: connection,
                  edit: true,
                  storage: storage,
                ),
                icon: const Icon(FluentIcons.add_connection)));
            if (buckets[connection.accessKey] != null) {
              flatBucketItems
                  .addAll(buckets[connection.accessKey]!.map((bucket) {
                return PaneItem(
                    body: BucketPage(
                        connection: connection,
                        bucket: bucket,
                        storage: storage),
                    title: Text(bucket.name),
                    icon: const Icon(FluentIcons.bucket_color_fill));
              }).toList());
            }
          }

          final List<NavigationPaneItem> footerItems = [
            PaneItemSeparator(),
            PaneItem(
              icon: const Icon(FluentIcons.add_connection),
              title: const Text('add_connection').tr(),
              body: EditPage(
                storage: storage,
                connection: Connection(),
              ),
            ),
            PaneItem(
              icon: const Icon(FluentIcons.settings),
              title: const Text('settings').tr(),
              body: const SettingsPage(),
            ),
          ];
          List<NavigationPaneItem> items = [
            ...originalItems,
            ...connectionItems
          ];

          if (state.search.isEmpty) {
            items = [...originalItems, ...connectionItems];
          } else {
            items = [
              ...originalItems,
              ...flatConnectionItems,
              ...flatBucketItems,
              ...footerItems
            ]
                .whereType<PaneItem>()
                .where((item) {
                  assert(item.title is Text);
                  final text = (item.title as Text).data!;
                  return text
                      .toLowerCase()
                      .contains(state.search.toLowerCase());
                })
                .toList()
                .cast<NavigationPaneItem>();
          }

          getSelectedIndex() {
            if (state.search.isEmpty) return state.tabIndex;

            final indexOnScreen = items.indexOf(
              [
                ...originalItems,
                ...flatConnectionItems,
                ...flatBucketItems,
                ...footerItems
              ].whereType<PaneItem>().elementAt(state.tabIndex),
            );
            if (indexOnScreen.isNegative) return 0;
            return indexOnScreen;
          }

          return NavigationView(
            pane: NavigationPane(
                header: const SizedBox(height: 10.0),
                indicator: const EndNavigationIndicator(),
                autoSuggestBox: TextBox(
                  controller: searchController,
                  focusNode: searchFocusNode,
                  key: key,
                  placeholder: tr('search'),
                  onChanged: (search) {
                    context
                        .read<HomePageBloc>()
                        .add(SearchChanged(search: search));
                  },
                ),
                autoSuggestBoxReplacement: const Icon(FluentIcons.search),
                items: items,
                footerItems: state.search.isNotEmpty ? [] : footerItems,
                selected: getSelectedIndex(),
                onChanged: (index) {
                  int computedIndex = index;

                  if (state.search.isNotEmpty) {
                    final equivalentIndex = [
                      ...originalItems,
                      ...flatConnectionItems,
                      ...flatBucketItems,
                      ...footerItems
                    ]
                        .whereType<PaneItem>()
                        .toList()
                        .indexOf(items[index] as PaneItem);
                    computedIndex = equivalentIndex;
                  }
                  context.read<HomePageBloc>().add(const SearchReset());
                  context
                      .read<HomePageBloc>()
                      .add(TabChanged(tabIndex: computedIndex));
                }),
            onOpenSearch: () {},
          );
        },
      ),
    );
  }
}
