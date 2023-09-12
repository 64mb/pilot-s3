import 'package:fluent_ui/fluent_ui.dart';
import 'package:pilot_s3/storage.dart';
import 'package:pilot_s3/widgets/dashboard_card.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key, required this.storage});

  final Storage storage;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: storage.getDashboardStatistic(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? GridView.extent(
                  primary: true,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  maxCrossAxisExtent: 340,
                  childAspectRatio: 1.5,
                  children: [
                    DashboardCard(
                        count: snapshot.data!['connections']!,
                        label: 'connections_plural'),
                    DashboardCard(
                        count: snapshot.data!['buckets']!,
                        label: 'buckets_plural'),
                  ],
                )
              : const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: ProgressRing(),
                  ),
                );
        });
  }
}
