import 'package:flutter/material.dart';

class SettingsTextBox extends StatelessWidget {
  const SettingsTextBox(
      {super.key, this.label = '', this.value = '', required this.onChanged});

  final String label;
  final String value;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: TextFormField(
      onChanged: onChanged,
      initialValue: value,
      decoration:
          InputDecoration(border: const OutlineInputBorder(), labelText: label),
    ));
  }
}
