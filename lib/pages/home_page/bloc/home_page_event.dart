part of 'home_page_bloc.dart';

abstract class HomePageEvent extends Equatable {
  const HomePageEvent();

  @override
  List<Object> get props => [];
}

class ConnectionsRequested extends HomePageEvent {
  const ConnectionsRequested();
}

class BucketsRequested extends HomePageEvent {
  const BucketsRequested();
}

class SearchChanged extends HomePageEvent {
  const SearchChanged({required this.search});

  final String search;

  @override
  List<Object> get props => [search];
}

class SearchReset extends HomePageEvent {
  const SearchReset();

  @override
  List<Object> get props => [];
}

class TabChanged extends HomePageEvent {
  const TabChanged({required this.tabIndex});

  final int tabIndex;

  @override
  List<Object> get props => [tabIndex];
}
