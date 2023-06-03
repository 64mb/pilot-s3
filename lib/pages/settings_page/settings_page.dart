import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilot_s3/pages/settings_page/bloc/settings_page_bloc.dart';
import 'package:pilot_s3/storage.dart';
import 'package:pilot_s3/widgets/settings_textbox.dart';
import 'package:pilot_s3/models/connection.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage(
      {super.key,
      this.connection = const Connection(),
      this.add = true,
      required this.storage});

  final Connection connection;
  final Storage storage;
  final bool add;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) => SettingsPageBloc(storage: storage)),
      child: BlocBuilder<SettingsPageBloc, SettingsPageState>(
          builder: ((context, state) {
        context
            .read<SettingsPageBloc>()
            .add(NameChanged(name: connection.name));
        context
            .read<SettingsPageBloc>()
            .add(EndpointChanged(endpoint: connection.endpoint));
        context
            .read<SettingsPageBloc>()
            .add(AccessKeyChanged(accessKey: connection.accessKey));
        context
            .read<SettingsPageBloc>()
            .add(SecretKeyChanged(secretKey: connection.secretKey));
        context
            .read<SettingsPageBloc>()
            .add(BucketChanged(bucket: connection.bucket));
        return SizedBox(
          width: 100,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SettingsTextBox(
                      label: 'Name',
                      value: connection.name,
                      onChanged: (value) {
                        context
                            .read<SettingsPageBloc>()
                            .add(NameChanged(name: value));
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  SettingsTextBox(
                      label: 'Endpoint',
                      value: connection.endpoint,
                      onChanged: (value) {
                        context
                            .read<SettingsPageBloc>()
                            .add(EndpointChanged(endpoint: value));
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  SettingsTextBox(
                      label: 'Access Key',
                      value: connection.accessKey,
                      onChanged: (value) {
                        context
                            .read<SettingsPageBloc>()
                            .add(AccessKeyChanged(accessKey: value));
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  SettingsTextBox(
                      label: 'Secret Key',
                      value: connection.secretKey,
                      onChanged: (value) {
                        context
                            .read<SettingsPageBloc>()
                            .add(SecretKeyChanged(secretKey: value));
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  SettingsTextBox(
                      label: 'Bucket',
                      value: connection.bucket ?? '',
                      onChanged: (value) {
                        context
                            .read<SettingsPageBloc>()
                            .add(BucketChanged(bucket: value));
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  Button(
                    child: add
                        ? const Text('Add connection')
                        : const Text('Save connection'),
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
