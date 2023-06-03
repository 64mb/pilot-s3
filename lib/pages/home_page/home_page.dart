import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minio/models.dart';
import 'package:pilot_s3/models/connection.dart';
import 'package:pilot_s3/pages/connection_page/connection_page.dart';
import 'package:pilot_s3/pages/home_page/bloc/home_page_bloc.dart';
import 'package:pilot_s3/pages/settings_page/settings_page.dart';
import 'package:pilot_s3/pages/bucket_page/bucket_page.dart';
import 'package:pilot_s3/storage.dart';
import 'package:pilot_s3/widgets/home_dashboard.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.storage});

  final Storage storage;

  List<NavigationPaneItem> getConnectionItems(
      List<Connection> connections, Map<String, List<Bucket>> buckets) {
    List<NavigationPaneItem> items = [
      PaneItemHeader(header: const Text('Connections')),
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
              icon: const Icon(FluentIcons.bucket_color_fill));
        }).toList();
      }
      items.add(PaneItemExpander(
          title: Text(connection.name),
          body: SettingsPage(
            storage: storage,
          ),
          items: bucketItems,
          icon: const Icon(FluentIcons.add_connection)));
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
            PaneItemHeader(header: const Text('Menu')),
            PaneItemSeparator(),
            PaneItem(
              icon: const Icon(FluentIcons.home),
              title: const Text('Home'),
              body: HomeDashboard(
                storage: storage,
              ),
            ),
          ];

          final List<Connection> connections = state.connections;
          final Map<String, List<Bucket>> buckets = state.buckets;

          List<NavigationPaneItem> connectionItems =
              getConnectionItems(connections, buckets);

          final List<NavigationPaneItem> footerItems = [
            PaneItemSeparator(),
            PaneItem(
              icon: const Icon(FluentIcons.settings),
              title: const Text('Settings'),
              body: SettingsPage(
                storage: storage,
              ),
            ),
          ];
          List<NavigationPaneItem> items = [
            ...originalItems,
            ...connectionItems
          ];

          if (state.search.isEmpty) {
            items = [...originalItems, ...connectionItems];
          } else {
            items = [...originalItems, ...connectionItems, ...footerItems]
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
              [...originalItems, ...connectionItems, ...footerItems]
                  .whereType<PaneItem>()
                  .elementAt(state.tabIndex),
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
                  placeholder: 'Search',
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
                      ...connectionItems,
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
