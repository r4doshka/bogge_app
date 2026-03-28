import 'package:bogge_app/ui/widgets/modals/widgets/modal_bottom_container.dart';
import 'package:bogge_app/ui/widgets/modals/widgets/modal_close_button.dart';
import 'package:bogge_app/ui/widgets/modals/widgets/modal_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showDefaultModalBottom<T>({
  required BuildContext context,
  required Widget child,
  T? contextProvider,
  bool isDismissible = true,
  bool? useRootNavigator,
  String? title,
  bool hasCloseButton = true,
  double? minHeight,
  bool shrinkWrap = true,
  void Function()? onClose,
  void Function()? onSkip,
  Widget Function()? contentRenderer,
  String? closeButtonText,
  bool withLine = true,
  String? modalName,
}) async {
  final mediaQuery = MediaQuery.of(context);
  final portraitWidth = mediaQuery.orientation == Orientation.portrait
      ? mediaQuery.size.width
      : mediaQuery.size.height;

  await showModalBottomSheet(
    context: context,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.94,
      minHeight: minHeight ?? MediaQuery.of(context).size.height * 0.3,
      maxWidth: portraitWidth,
    ),
    isDismissible: isDismissible,
    enableDrag: isDismissible,
    useRootNavigator: true,
    routeSettings: RouteSettings(name: modalName),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (builder) {
      return Padding(
        padding: MediaQuery.of(builder).viewInsets,
        child: ModalBottomContainer(
          shrinkWrap: shrinkWrap,
          withLine: withLine,
          contentRenderer: contentRenderer,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 80.w,
                  child: hasCloseButton
                      ? ModalCloseButton(
                          onClose: onClose,
                          text: closeButtonText,
                        )
                      : const SizedBox(),
                ),
                Expanded(
                  child: title != null && title.isNotEmpty
                      ? ModalTitle(label: title)
                      : const SizedBox(),
                ),
                SizedBox(width: 80.w, child: const SizedBox()),
              ],
            ),
            child,
          ],
        ),
      );
    },
  ).then((value) {
    if (onSkip != null) onSkip();
  });
}
