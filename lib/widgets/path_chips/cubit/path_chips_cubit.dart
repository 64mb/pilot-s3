import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'path_chips_state.dart';

class PathChipsCubit extends Cubit<PathChipsState> {
  PathChipsCubit() : super(const PathChipsState());

  void setHover(bool isHovered) => emit(PathChipsState(isHovered: isHovered));
}
