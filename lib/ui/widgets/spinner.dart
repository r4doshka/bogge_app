import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Spinner extends ConsumerWidget {
  final double height;
  final double width;
  final double strokeWidth;
  final Color? strokeColor;

  const Spinner({
    this.height = 32,
    this.width = 32,
    this.strokeWidth = 3,
    this.strokeColor,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    final color = strokeColor ?? palette.white;

    return Center(
      child: SizedBox(
        width: width.w,
        height: height.w,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color),
          strokeWidth: strokeWidth.w,
        ),
      ),
    );
  }
}
