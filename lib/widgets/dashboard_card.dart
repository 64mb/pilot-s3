import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({super.key, this.label = '', this.count = 0});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 140,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[100]),
          borderRadius: BorderRadius.circular(6),
          color: Colors.grey[190]),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              count.toString(),
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 48),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 18),
            ).plural(count)
          ]),
    );
  }
}
