part of 'home_page_bloc.dart';

class HomePageState extends Equatable {
  const HomePageState(
      {this.connections = const [],
      this.search = '',
      this.tabIndex = 0,
      this.buckets = const {}});

  final List<Connection> connections;
  final String search;
  final int tabIndex;
  final Map<String, List<Bucket>> buckets;

  HomePageState copyWith(
      {List<Connection> Function()? connections,
      String? search,
      int? tabIndex,
      Map<String, List<Bucket>> Function()? buckets}) {
    return HomePageState(
        connections: connections != null ? connections() : this.connections,
        search: search ?? this.search,
        tabIndex: tabIndex ?? this.tabIndex,
        buckets: buckets != null ? buckets() : this.buckets);
  }

  @override
  List<Object> get props => [connections, search, tabIndex, buckets];
}
