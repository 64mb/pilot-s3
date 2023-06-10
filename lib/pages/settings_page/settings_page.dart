import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilot_s3/pages/settings_page/bloc/settings_page_bloc.dart';
import 'package:pilot_s3/storage.dart';
import 'package:pilot_s3/widgets/settings_textbox.dart';
import 'package:pilot_s3/widgets/settings_body.dart';
import 'package:pilot_s3/models/connection.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage(
      {super.key,
      this.connection = const Connection(),
      this.edit = false,
      required this.storage});

  final Connection connection;
  final Storage storage;
  final bool edit;

  Row getEditButtons(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Button(
        child: const Text('Delete connection'),
        onPressed: () async {
          showDialog<String>(
              context: context,
              builder: (context) => ContentDialog(
                    title: const Text('Delete file permanently?'),
                    content: const Text(
                      'Are you sure you want to delete this connection?',
                    ),
                    actions: [
                      Button(
                        onPressed: () {
                          storage.deleteConnection(connection);
                          Navigator.pop(context, 'User deleted connection');
                        },
                        child: const Text('Delete'),
                      ),
                      Button(
                        onPressed: () {
                          Navigator.pop(context, 'User canceled dialog');
                        },
                        child: const Text('Cancel'),
                      )
                    ],
                  ));
        },
      ),
      const SizedBox(
        width: 20,
      ),
      Button(
        child: const Text('Save connection'),
        onPressed: () async {
          context
              .read<SettingsPageBloc>()
              .add(SaveSubmitted(connection: connection));
        },
      ),
    ]);
  }

  Row getCreateButtons(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Button(
        child: const Text('Add connection'),
        onPressed: () async {
          context.read<SettingsPageBloc>().add(const AddSubmitted());
        },
      ),
    ]);
  }

  Row getButtons(bool edit, BuildContext context) {
    if (edit) {
      return getEditButtons(context);
    }
    return getCreateButtons(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) => SettingsPageBloc(storage: storage)),
      child: BlocBuilder<SettingsPageBloc, SettingsPageState>(
          builder: ((context, state) {
        return SettingsBody(
          onInit: () {
            context
                .read<SettingsPageBloc>()
                .add(InitConnectionState(connection: connection));
          },
          padding: Padding(
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
                  getButtons(edit, context)
                ],
              )),
        );
      })),
    );
  }
}
