import 'package:flutter/material.dart';

class DismissKeyboardContainer extends StatelessWidget {
  final Widget child;
  final void Function()? onAction;

  const DismissKeyboardContainer({
    super.key,
    required this.child,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onAction != null) onAction!();
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Container(color: Colors.transparent, child: child),
    );
  }
}
