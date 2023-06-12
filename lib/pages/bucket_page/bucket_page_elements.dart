part of 'bucket_page.dart';

class StateIconCircle extends StatefulWidget {
  const StateIconCircle({super.key});
  @override
  State<StateIconCircle> createState() => _StateIconCircle();
}

class _StateIconCircle extends State<StateIconCircle> {
  Icon firstState = const Icon(FluentIcons.circle_ring);
  Icon secondState = const Icon(FluentIcons.circle_fill);
  Icon currentState = const Icon(FluentIcons.circle_ring);
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: currentState,
        onPressed: () {},
        onTapDown: () {
          setState(() {
            if (currentState != secondState) {
              currentState = secondState;
            } else {
              currentState = firstState;
            }
          });
        });
  }
}
