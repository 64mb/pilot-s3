import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilot_s3/widgets/path_chips/cubit/path_chips_cubit.dart';

class PathChips extends StatelessWidget {
  const PathChips({super.key, this.label = '', required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PathChipsCubit(),
      child: BlocBuilder<PathChipsCubit, PathChipsState>(
        builder: (context, state) {
          return MouseRegion(
            onEnter: (event) {
              context.read<PathChipsCubit>().setHover(true);
            },
            onExit: (event) {
              context.read<PathChipsCubit>().setHover(false);
            },
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color:
                        state.isHovered ? Colors.grey[150] : Colors.grey[170]),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
