import 'package:fluent_ui/fluent_ui.dart';

class EditTextBox extends StatefulWidget {
  const EditTextBox(
      {Key? key,
      this.label = '',
      this.value = '',
      required this.onChanged,
      this.passwordMode = false})
      : super(key: key);
  final String label;
  final String value;
  final Function(String) onChanged;
  final bool passwordMode;

  @override
  StateEditTextBox createState() => StateEditTextBox();
}

class StateEditTextBox extends State<EditTextBox> {
  final TextEditingController _controller = TextEditingController();
  bool showPassword = false;

  @override
  void initState() {
    _controller.text = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextBox(
      controller: _controller,
      obscureText: !showPassword && widget.passwordMode,
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
      suffix: widget.passwordMode?GestureDetector(
        child: Row(
          children: [
            Icon(
              showPassword ? FluentIcons.hide3 : FluentIcons.red_eye,
            ),
            const SizedBox(
              width: 8,
            )
          ],
        ),
        onTap: () {
          setState(() {
            showPassword = !showPassword;
          });
        },
      ): Container(),
      //onChanged: onChanged,
      expands: false,
    );
  }
}
