import 'package:fluent_ui/fluent_ui.dart';

class EditBody extends StatefulWidget {
  const EditBody({Key? key, required this.onInit, required this.padding})
      : super(key: key);
  final Function onInit;
  final Padding padding;

  @override
  StateEditBody createState() => StateEditBody();
}

class StateEditBody extends State<EditBody> {
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
