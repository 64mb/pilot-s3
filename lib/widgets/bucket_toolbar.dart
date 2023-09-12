import 'package:fluent_ui/fluent_ui.dart';
import 'package:pilot_s3/widgets/path_chips/path_chips.dart';

class BucketToolbar extends StatelessWidget {
  const BucketToolbar(
      {super.key,
      this.path = const [],
      required this.onRefresh,
      required this.onChange,
      required this.onUpload});

  final List<String> path;
  final VoidCallback onRefresh;
  final Function(List<String> path) onChange;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    List<String> fullPath = [];

    for (String prefix in path) {
      fullPath.add(prefix);
      List<String> widgetPath = [...fullPath];
      widgets.addAll([
        Text(
          '/',
          style: TextStyle(color: Colors.grey[120]),
        ),
        const SizedBox(
          width: 2,
        ),
        PathChips(
          label: prefix,
          onTap: () {
            onChange(widgetPath);
          },
        ),
        const SizedBox(
          width: 2,
        )
      ]);
    }

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          IconButton(
              icon: const Icon(FluentIcons.refresh), onPressed: onRefresh),
          const SizedBox(
            width: 6,
          ),
          IconButton(
              icon: const Icon(FluentIcons.home),
              onPressed: () {
                onChange([]);
              }),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widgets,
              ),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          IconButton(
            icon: const Icon(FluentIcons.add),
            onPressed: onUpload,
          ),
        ],
      ),
    );
  }
}
