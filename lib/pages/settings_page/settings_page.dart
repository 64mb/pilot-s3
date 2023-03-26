import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilot_s3/pages/settings_page/bloc/settings_page_bloc.dart';
import 'package:pilot_s3/storage.dart';

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
                  TextBox(
                    onChanged: (value) {
                      context
                          .read<SettingsPageBloc>()
                          .add(NameChanged(name: value));
                    },
                    outsidePrefix: Row(children: const [
                      SizedBox(
                        width: 100,
                        child: Text('Name'),
                      ),
                      SizedBox(
                        width: 12,
                      )
                    ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextBox(
                    onChanged: (value) {
                      context
                          .read<SettingsPageBloc>()
                          .add(EndpointChanged(endpoint: value));
                    },
                    outsidePrefix: Row(children: const [
                      SizedBox(
                        width: 100,
                        child: Text('Endpoint'),
                      ),
                      SizedBox(
                        width: 12,
                      )
                    ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextBox(
                    onChanged: (value) {
                      context
                          .read<SettingsPageBloc>()
                          .add(AccessKeyChanged(accessKey: value));
                    },
                    outsidePrefix: Row(children: const [
                      SizedBox(
                        width: 100,
                        child: Text('Access key'),
                      ),
                      SizedBox(
                        width: 12,
                      )
                    ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextBox(
                    onChanged: (value) {
                      context
                          .read<SettingsPageBloc>()
                          .add(SecretKeyChanged(secretKey: value));
                    },
                    outsidePrefix: Row(children: const [
                      SizedBox(
                        width: 100,
                        child: Text('Secret key'),
                      ),
                      SizedBox(
                        width: 12,
                      )
                    ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Button(
                    child: const Text('Добавить подключение'),
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
