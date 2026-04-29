import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RequirementItem extends ConsumerWidget {
  final bool isValid;
  final String text;
  final Color? svgColor;

  const RequirementItem({
    super.key,
    required this.isValid,
    required this.text,
    this.svgColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);

    return Row(
      children: [
        SvgPicture.asset(
          isValid
              ? 'assets/icons/check-icon.svg'
              : 'assets/icons/cross-icon.svg',
          width: AppSpace.s20.w,
          height: AppSpace.s20.h,
          colorFilter: svgColor != null
              ? ColorFilter.mode(svgColor!, BlendMode.srcIn)
              : null,
        ),
        AppSpace.w4,
        Text(text, style: text_s11_w400_lsm043.copyWith(color: palette.text30)),
      ],
    );
  }
}
