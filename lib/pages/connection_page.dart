import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:pilot_s3/models/connection.dart';

class ConnectionPage extends StatelessWidget {
  const ConnectionPage(
      {super.key,
      required this.connection,
      this.onDeletePressed,
      this.onEditPressed});

  final Connection connection;
  final Function()? onDeletePressed;
  final Function()? onEditPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                initialValue: connection.name,
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
              Button(
                onPressed: onEditPressed,
                child: const Text('Save connection'),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
