import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilot_s3/pages/edit_page/bloc/edit_page_bloc.dart';
import 'package:pilot_s3/storage.dart';
import 'package:pilot_s3/widgets/edit_textbox.dart';
import 'package:pilot_s3/models/connection.dart';

class EditPage extends StatelessWidget {
  final Connection connection;
  final Storage storage;
  final bool edit;

  const EditPage({
    super.key,
    this.edit = false,
    required this.storage,
    required this.connection,
  });

  Wrap getEditButtons(BuildContext context) {
    return Wrap(
        spacing: 20,
        runSpacing: 12,
        alignment: WrapAlignment.end,
        children: [
          Button(
            child: const Text('delete_connection').tr(),
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (context) => ContentDialog(
                        title:
                            const Text('delete_connection_confirmation_title')
                                .tr(),
                        content: const Text(
                          'delete_connection_confirmation_description',
                        ).tr(),
                        actions: [
                          Button(
                            onPressed: () {
                              storage.deleteConnection(connection);
                              Navigator.pop(context);
                            },
                            child: const Text('delete').tr(),
                          ),
                          FilledButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('cancel').tr(),
                          )
                        ],
                      ));
            },
          ),
          Button(
            child: const Text('save_connection').tr(),
            onPressed: () async {
              context
                  .read<EditPageBloc>()
                  .add(SaveSubmitted(connection: connection));
            },
          ),
        ]);
  }

  Wrap getCreateButtons(BuildContext context) {
    return Wrap(children: [
      Button(
        child: const Text('add_connection').tr(),
        onPressed: () async {
          context.read<EditPageBloc>().add(const AddSubmitted());
        },
      ),
    ]);
  }

  Wrap getButtons(bool edit, BuildContext context) {
    if (edit) {
      return getEditButtons(context);
    }
    return getCreateButtons(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) => EditPageBloc(connection, storage: storage)),
      child:
          BlocBuilder<EditPageBloc, EditPageState>(builder: ((context, state) {
        return SizedBox(
          width: 100,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  EditTextBox(
                      label: tr('name'),
                      value: connection.name,
                      onChanged: (value) {
                        context
                            .read<EditPageBloc>()
                            .add(NameChanged(name: value));
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  EditTextBox(
                      label: 'Endpoint',
                      value: connection.endpoint,
                      onChanged: (value) {
                        context
                            .read<EditPageBloc>()
                            .add(EndpointChanged(endpoint: value));
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  EditTextBox(
                      label: 'Access Key',
                      value: connection.accessKey,
                      onChanged: (value) {
                        context
                            .read<EditPageBloc>()
                            .add(AccessKeyChanged(accessKey: value));
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  EditTextBox(
                      label: 'Secret Key',
                      value: connection.secretKey,
                      passwordMode: true,
                      onChanged: (value) {
                        context
                            .read<EditPageBloc>()
                            .add(SecretKeyChanged(secretKey: value));
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  EditTextBox(
                      label: tr('bucket'),
                      value: connection.bucket ?? '',
                      onChanged: (value) {
                        context
                            .read<EditPageBloc>()
                            .add(BucketChanged(bucket: value));
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  getButtons(edit, context),
                ],
              )),
        );
      })),
    );
  }
}
