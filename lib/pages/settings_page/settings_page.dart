import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilot_s3/pages/settings_page/bloc/settings_page_bloc.dart';
import 'package:pilot_s3/storage.dart';
import 'package:pilot_s3/widgets/settings_textbox.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.storage});

  final Storage storage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) => SettingsPageBloc(storage: storage)),
      child: BlocBuilder<SettingsPageBloc, SettingsPageState>(
          builder: ((context, state) {
        return SizedBox(
          width: 100,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SettingsCheckbox(
                      label: 'Name',
                      onChanged: (value) {
                        context
                            .read<SettingsPageBloc>()
                            .add(NameChanged(name: value));
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  SettingsCheckbox(
                      label: 'Endpoint',
                      onChanged: (value) {
                        context
                            .read<SettingsPageBloc>()
                            .add(EndpointChanged(endpoint: value));
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  SettingsCheckbox(
                      label: 'Access Key',
                      onChanged: (value) {
                        context
                            .read<SettingsPageBloc>()
                            .add(AccessKeyChanged(accessKey: value));
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  SettingsCheckbox(
                      label: 'Secret Key',
                      onChanged: (value) {
                        context
                            .read<SettingsPageBloc>()
                            .add(SecretKeyChanged(secretKey: value));
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  SettingsCheckbox(
                      label: 'Bucket',
                      onChanged: (value) {
                        context
                            .read<SettingsPageBloc>()
                            .add(BucketChanged(bucket: value));
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  Button(
                    child: const Text('Add connection'),
                    onPressed: () async {
                      context
                          .read<SettingsPageBloc>()
                          .add(const AddSubmitted());
                    },
                  ),
                ],
              )),
        );
      })),
    );
  }
}
