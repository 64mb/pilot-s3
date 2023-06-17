import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      child: Column(
        children: [
          Row(children: [
            const Text('language').tr(),
            const SizedBox(
              width: 20,
            ),
            ComboBox(
              onChanged: (value) {
                if (value != null) context.setLocale(Locale(value));
              },
              value: context.locale.languageCode,
              items: const [
                ComboBoxItem(value: 'en', child: Text('English')),
                ComboBoxItem(value: 'ru', child: Text('Русский')),
              ],
            )
          ])
        ],
      ),
    );
  }
}
