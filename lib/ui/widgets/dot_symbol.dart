import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_border_radius.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DotSymbol extends ConsumerWidget {
  const DotSymbol({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);
    return Container(
      margin: EdgeInsetsDirectional.only(top: AppSpace.s8.h),
      width: 3.w,
      height: 3.w,
      decoration: BoxDecoration(
        color: palette.text,
        borderRadius: AppBorderRadius.all12,
      ),
    );
  }
}
