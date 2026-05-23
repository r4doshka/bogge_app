import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/countdown_progress_circle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CountdownTimerCircle extends HookConsumerWidget {
  final int seconds;
  final VoidCallback? onFinished;

  const CountdownTimerCircle({super.key, this.seconds = 3, this.onFinished});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    final started = useState(false);

    final controller = useAnimationController(
      duration: Duration(seconds: seconds),
    );

    final pulseController = useAnimationController(
      duration: const Duration(milliseconds: 520),
    );

    final progress = useAnimation(controller);
    final pulseProgress = useAnimation(pulseController);

    useEffect(() {
      Future.delayed(const Duration(seconds: 1), () {
        if (!context.mounted) return;

        started.value = true;
        controller.forward();
        pulseController.forward(from: 0);
      });

      void statusListener(AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          onFinished?.call();
        }
      }

      controller.addStatusListener(statusListener);

      return () {
        controller.removeStatusListener(statusListener);
      };
    }, const []);

    final currentSecond = ((1 - progress) * seconds).ceil().clamp(0, seconds);

    useEffect(() {
      if (started.value && currentSecond > 0) {
        pulseController.forward(from: 0);
      }

      return null;
    }, [currentSecond]);

    return CountdownProgressCircle(
      progress: started.value ? (1 - progress) : 1,
      pulseProgress: pulseProgress,
      activeColor: const Color(0xFFA88772),
      inactiveColor: const Color(0xFFE2D8D1),
      pulseColor: const Color(0xFFA88772),
      child: Text(
        !started.value ? 'На старт!'.tr() : '$currentSecond',
        style: text_s34_w700_ls04.copyWith(color: palette.text),
      ),
    );
  }
}
