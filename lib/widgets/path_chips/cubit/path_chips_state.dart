part of 'path_chips_cubit.dart';

class PathChipsState extends Equatable {
  const PathChipsState({this.isHovered = false});

  final bool isHovered;

  @override
  List<Object> get props => [isHovered];
}

