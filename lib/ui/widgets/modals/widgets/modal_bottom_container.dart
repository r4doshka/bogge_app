import 'package:bogge_app/utils/color_extensions.dart';
import 'package:bogge_app/utils/ui_tokens/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ModalBottomContainer extends StatelessWidget {
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

  Widget _buildLine() {
    return Center(
      child: Container(
        height: 5.h,
        width: 36.w,
        margin: EdgeInsetsDirectional.only(top: 4.h),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(2.5)),
          color: AppPalette.white.withSafeOpacity(0.3),
        ),
      ),
    );
  }

  @override
  Widget build(context) {
    return Container(
      decoration: BoxDecoration(
        image: bgImage,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: AppPalette.bgDark,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (withLine) ...[_buildLine(), SizedBox(height: 22.h)],
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
