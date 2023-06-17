import 'package:fluent_ui/fluent_ui.dart';

class EditTextBox extends StatefulWidget {
  const EditTextBox(
      {Key? key, this.label = '', this.value = '', required this.onChanged})
      : super(key: key);
  final String label;
  final String value;
  final Function(String) onChanged;

  @override
  StateEditTextBox createState() => StateEditTextBox();
}

class StateEditTextBox extends State<EditTextBox> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextBox(
      controller: _controller,
      onChanged: widget.onChanged,
      prefix: Row(children: [
        const SizedBox(
          width: 8,
        ),
        Text(
          widget.label,
          style: const TextStyle(
              fontSize: 14, color: Color.fromARGB(255, 150, 150, 150)),
        )
      ]),
      //onChanged: onChanged,
      expands: false,
    );
  }
}
