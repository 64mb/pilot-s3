import 'package:fluent_ui/fluent_ui.dart';

class SettingsCheckbox extends StatelessWidget {
  const SettingsCheckbox({super.key, this.label = '', required this.onChanged});

  final String label;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextBox(
      onChanged: onChanged,
      prefix: Row(children: [
        const SizedBox(
          width: 12,
        ),
        SizedBox(
          width: 100,
          child: Text(label),
        ),
        const SizedBox(
          width: 12,
        )
      ]),
    );
  }
}
