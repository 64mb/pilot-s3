import 'package:fluent_ui/fluent_ui.dart';

class BucketToolbar extends StatelessWidget {
  const BucketToolbar(
      {super.key,
      this.path = '',
      required this.onRefresh,
      required this.onUpload});

  final String path;
  final VoidCallback onRefresh;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          IconButton(
              icon: const Icon(FluentIcons.refresh), onPressed: onRefresh),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text('/$path', style: const TextStyle(fontSize: 16)),
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
