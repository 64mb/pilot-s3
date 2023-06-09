import 'package:fluent_ui/fluent_ui.dart';

class SettingsBody extends StatefulWidget {
  const SettingsBody({Key? key, required this.onInit, required this.padding})
      : super(key: key);
  final Function onInit;
  final Padding padding;

  @override
  StateSettingsBody createState() => StateSettingsBody();
}

class StateSettingsBody extends State<SettingsBody> {
  @override
  void initState() {
    widget.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 100, child: widget.padding);
  }
}
