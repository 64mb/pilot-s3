import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilot_s3/widgets/path_chips/cubit/path_chips_cubit.dart';

void main() {
  group('PathChipsCubit', () {
    late PathChipsCubit pathChipsCubit;

    setUp(() {
      pathChipsCubit = PathChipsCubit();
    });
    test('isHovered in initial state is false', () {
      expect(pathChipsCubit.state, const PathChipsState(isHovered: false));
    });
    blocTest<PathChipsCubit, PathChipsState>(
      'emits [PathChipsState] when setHover is added.',
      build: () => PathChipsCubit(),
      act: (cubit) => cubit.setHover(true),
      expect: () => const <PathChipsState>[PathChipsState(isHovered: true)],
    );
  });
}
