import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ModalCloseButton extends ConsumerWidget {
  final void Function()? onClose;

  const ModalCloseButton({this.onClose, super.key});

  @override
  Widget build(context, ref) {
    final palette = ref.watch(paletteProvider);

    return PrimaryIconButton(
      svgPath: 'assets/icons/chevron-left-icon.svg',
      iconWidth: AppSpace.s12.w,
      iconHeight: 18.h,
      containerHeight: AppSpace.s44.w,
      containerWidth: AppSpace.s44.w,
      backgroundColor: palette.primary12,
      onPress: () {
        if (onClose != null) {
          onClose!();
        }
        context.router.pop();
      },
    );
  }
}
