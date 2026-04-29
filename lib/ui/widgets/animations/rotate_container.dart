import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RotateContainer extends HookWidget {
  final Widget child;
  final bool value;
  final int duration;

  const RotateContainer({
    super.key,
    required this.child,
    required this.value,
    this.duration = 300,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: Duration(milliseconds: duration),
    );

    useEffect(() {
      if (value) {
        controller.forward();
      } else {
        controller.reverse();
      }

      return null;
    }, [value]);

    return RotationTransition(
      turns: Tween(begin: 0.0, end: 0.5).animate(controller),
      child: child,
    );
  }
}
