import 'dart:ui';

import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/utils/color_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BluetoothPulse extends HookConsumerWidget {
  final double size;

  const BluetoothPulse({super.key, this.size = 102});

  static const _waves = 4;

  double _waveValue(double animationValue, int index) {
    final delay = index / _waves;
    return (animationValue - delay) % 1.0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);

    final controller = useAnimationController(
      duration: const Duration(milliseconds: 3200),
    )..repeat();

    final animation = useAnimation(controller);

    final centerSize = size.w;
    final maxSize = centerSize * 3.6;

    return SizedBox(
      width: maxSize,
      height: maxSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (int i = _waves - 1; i >= 0; i--)
            Builder(
              builder: (_) {
                final value = _waveValue(animation, i);

                final waveSize = lerpDouble(centerSize, maxSize, value)!;

                final opacity = (1 - value).clamp(0.0, 1.0) * 0.68;

                return Container(
                  width: waveSize,
                  height: waveSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: palette.primary.withSafeOpacity(opacity),
                  ),
                );
              },
            ),

          Container(
            width: centerSize,
            height: centerSize,
            decoration: BoxDecoration(
              color: palette.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: SizedBox(
              width: 38.w,
              height: AppSpace.s44,
              child: SvgPicture.asset(
                'assets/icons/bluetooth-icon.svg',
                colorFilter: ColorFilter.mode(palette.white, BlendMode.srcIn),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
