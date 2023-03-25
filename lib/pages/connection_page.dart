import 'package:fluent_ui/fluent_ui.dart';
import 'package:pilot_s3/models/connection.dart';

class ConnectionPage extends StatelessWidget {
  const ConnectionPage(
      {super.key, required this.connection, this.onDeletePressed});

  final Connection connection;
  final Function()? onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Column(
            children: [
              Text(connection.name),
              const SizedBox(
                height: 20,
              ),
              Text(connection.endpoint),
              const SizedBox(
                height: 20,
              ),
              Text(connection.accessKey),
              const SizedBox(
                height: 20,
              ),
              Text(connection.secretKey),
            ],
          ),
          const SizedBox(
            height: 60,
          ),
          Button(
            onPressed: onDeletePressed,
            child: const Text('Delete connection'),
          )
        ],
      ),
    );
  }
}
