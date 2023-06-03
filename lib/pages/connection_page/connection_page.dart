import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:pilot_s3/models/connection.dart';

class ConnectionPage extends StatelessWidget {
  const ConnectionPage(
      {super.key,
      required this.connection,
      this.onDeletePressed,
      this.onSavePressed});

  final Connection connection;
  final Function()? onDeletePressed;
  final Function()? onSavePressed;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: TextEditingController(
                    text: "Complete the story from here..."),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Connection name'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: connection.endpoint,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Endpoint'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: connection.accessKey,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Access key'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: connection.secretKey,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Secret key'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: connection.bucket ?? '',
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Bucket'),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Button(
                onPressed: onDeletePressed,
                child: const Text('Delete connection'),
              ),
              const SizedBox(
                width: 10,
              ),
              IgnorePointer(
                  ignoring: true,
                  child: Button(
                    onPressed: onSavePressed,
                    child: const Text('Save connection'),
                  )),
            ],
          )
        ],
      ),
    ));
  }
}
