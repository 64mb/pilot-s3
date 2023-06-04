part of 'bucket_page.dart';

class StateIconCircle extends StatefulWidget {
  const StateIconCircle({super.key});
  @override
  State<StateIconCircle> createState() => _StateIconCircle();
}

class _StateIconCircle extends State<StateIconCircle> {
  Icon first_state = Icon(FluentIcons.circle_ring);
  Icon second_state = Icon(FluentIcons.circle_fill);
  Icon current_state = Icon(FluentIcons.circle_ring);
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: current_state,
        onPressed: () {},
        onTapDown: () {
          setState(() {
            if (current_state != second_state) {
              current_state = second_state;
            } else {
              current_state = first_state;
            }
          });
        });
  }
}
