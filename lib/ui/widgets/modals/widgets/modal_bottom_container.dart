import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ModalBottomContainer extends ConsumerWidget {
  final List<Widget> children;
  final bool shrinkWrap;
  final DecorationImage? bgImage;
  final bool withLine;
  final Widget Function()? contentRenderer;

  const ModalBottomContainer({
    super.key,
    required this.children,
    this.shrinkWrap = true,
    this.withLine = true,
    this.bgImage,
    this.contentRenderer,
  });

  Widget _buildLine(AppPalette palette) {
    return Center(
      child: Container(
        height: 5.h,
        width: AppSpace.s36.w,
        margin: EdgeInsetsDirectional.only(top: AppSpace.s4.h),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(2.5)),
          color: palette.text30,
        ),
      ),
    );
  }

  @override
  Widget build(context, ref) {
    final palette = ref.watch(paletteProvider);

    return Container(
      decoration: BoxDecoration(
        image: bgImage,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: palette.bgLight,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (withLine) ...[_buildLine(palette), SizedBox(height: 6.h)],
          if (contentRenderer != null)
            contentRenderer!()
          else
            Flexible(
              child: CustomScrollView(
                shrinkWrap: shrinkWrap,
                slivers: [
                  MultiSliver(
                    children: [
                      if (shrinkWrap)
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: children,
                        )
                      else
                        ...children,
                      if (shrinkWrap)
                        SizedBox(height: MediaQuery.of(context).padding.bottom),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
