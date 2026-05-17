import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_icon_button.dart';
import 'package:bogge_app/utils/box_shadows.dart';
import 'package:bogge_app/utils/color_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CheckButton extends ConsumerWidget {
  final void Function()? onPress;

  const CheckButton({this.onPress, super.key});

  @override
  Widget build(context, ref) {
    final palette = ref.watch(paletteProvider);

    return Container(
      decoration: BoxDecoration(boxShadow: AppBoxShadows.defaultBoxShadow),
      child: PrimaryIconButton(
        svgPath: 'assets/icons/check2-icon.svg',
        iconWidth: AppSpace.s20.spMin,
        iconHeight: AppSpace.s20.spMin,
        containerHeight: AppSpace.s44.spMin,
        containerWidth: AppSpace.s44.spMin,
        backgroundColor: onPress != null
            ? palette.primary
            : palette.primary.withSafeOpacity(0.4),
        border: Border.all(color: palette.white30, width: AppSpace.s2.spMin),
        onPress: onPress,
      ),
    );
  }
}
