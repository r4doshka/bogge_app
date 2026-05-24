import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_border_radius.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/services.dart';

class CustomSwipeSwitch extends HookConsumerWidget {
  /// true = locked
  /// false = unlocked
  final bool value;

  final Color? colorActive;
  final Color? colorDisabled;
  final void Function(bool value)? onChange;

  const CustomSwipeSwitch({
    super.key,
    required this.value,
    this.onChange,
    this.colorActive,
    this.colorDisabled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    final controller = useAnimationController(
      duration: const Duration(milliseconds: 500),
      initialValue: value ? 0 : 1,
    );

    final isDragging = useRef(false);
    final showUnlockIcon = useState(!value);

    useEffect(() {
      if (!isDragging.value) {
        controller.value = value ? 0 : 1;
        showUnlockIcon.value = !value;
      }

      return null;
    }, [value]);

    final progress = useAnimation(controller);

    final activeColor = colorActive ?? palette.primary12;
    final disabledColor = colorDisabled ?? palette.primary12;
    final scale = 1 + (0.06 * progress);

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = 84.h;
        final padding = 6.spMin;
        final thumbSize = 72.h;
        final maxOffset = constraints.maxWidth - thumbSize - padding * 2;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: onChange == null
              ? null
              : (_) {
                  controller.stop();
                  isDragging.value = true;
                  showUnlockIcon.value = false;
                },
          onHorizontalDragUpdate: onChange == null
              ? null
              : (details) {
                  controller.value =
                      (controller.value + details.delta.dx / maxOffset).clamp(
                        0.0,
                        1.0,
                      );

                  showUnlockIcon.value = controller.value >= 0.65;
                },
          onHorizontalDragEnd: onChange == null
              ? null
              : (_) async {
                  isDragging.value = false;

                  if (controller.value >= 0.5) {
                    final startedAt = DateTime.now();

                    showUnlockIcon.value = true;

                    await controller.animateTo(
                      1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.fastLinearToSlowEaseIn,
                    );

                    final elapsed = DateTime.now().difference(startedAt);
                    final minDelay = const Duration(milliseconds: 350);

                    if (elapsed < minDelay) {
                      await Future.delayed(minDelay - elapsed);
                    }

                    if (value) {
                      HapticFeedback.mediumImpact();
                      onChange?.call(false);
                    }
                  } else {
                    showUnlockIcon.value = false;

                    await controller.animateTo(
                      0,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.fastLinearToSlowEaseIn,
                    );

                    if (!value) {
                      onChange?.call(true);
                    }
                  }
                },
          onHorizontalDragCancel: onChange == null
              ? null
              : () async {
                  isDragging.value = false;
                  showUnlockIcon.value = !value;

                  await controller.animateTo(
                    value ? 0 : 1,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.fastLinearToSlowEaseIn,
                  );
                },
          child: Container(
            width: double.infinity,
            height: height,
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: value ? activeColor : disabledColor,
              borderRadius: AppBorderRadius.all100,
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: thumbSize + 16.w,
                      end: 16.w,
                    ),
                    child: Opacity(
                      opacity: (1 - progress).clamp(0.0, 1.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Разблокировать'.tr(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text_s28_w600_lsm043.copyWith(
                            color: palette.text60,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(maxOffset * progress, 0),
                  child: Transform.scale(
                    scale: scale,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      width: thumbSize,
                      height: thumbSize,
                      decoration: BoxDecoration(
                        color: palette.primary30,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                            color: palette.bgDark.withValues(alpha: 0.18),
                          ),
                        ],
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                scale: animation,
                                child: child,
                              ),
                            );
                          },
                          child: SvgPicture.asset(
                            showUnlockIcon.value
                                ? 'assets/icons/unlock-icon.svg'
                                : 'assets/icons/lock-icon.svg',
                            key: ValueKey(showUnlockIcon.value),
                            width: AppSpace.s44.spMin,
                            height: AppSpace.s44.spMin,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
