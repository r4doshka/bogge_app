import 'dart:async';
import 'package:bogge_app/providers/shared_preferences_provider.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const resendCodeMinutes = 1;

class ResendTimer extends HookConsumerWidget {
  final void Function() onResend;
  final String value;

  const ResendTimer(this.onResend, this.value, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);
    final preferences = ref.read(sharedPreferencesServiceProvider);

    final remaining = useState<Duration>(
      const Duration(minutes: resendCodeMinutes),
    );

    final timerRef = useRef<Timer?>(null);

    void tick(Timer timer) {
      final next = remaining.value - const Duration(seconds: 1);

      if (next.inSeconds <= 0) {
        remaining.value = Duration.zero;
        timer.cancel();
        return;
      }

      remaining.value = next;
    }

    void startTimer() {
      final savedSendTime = preferences.getSendEmailTimeByEmail(value);

      final now = DateTime.now();

      if (savedSendTime != null) {
        final parsed = DateTime.parse(savedSendTime);
        final end = parsed.add(const Duration(minutes: resendCodeMinutes));

        final diff = end.difference(now);

        if (diff.isNegative) {
          remaining.value = const Duration(minutes: resendCodeMinutes);

          preferences.setSendEmailTimeByEmail(now.toIso8601String(), value);
        } else {
          remaining.value = diff;
        }
      } else {
        remaining.value = const Duration(minutes: resendCodeMinutes);

        preferences.setSendEmailTimeByEmail(now.toIso8601String(), value);
      }

      timerRef.value?.cancel();
      timerRef.value = Timer.periodic(const Duration(seconds: 1), tick);
    }

    void resetTimer() {
      final now = DateTime.now();

      remaining.value = const Duration(minutes: resendCodeMinutes);

      preferences.setSendEmailTimeByEmail(now.toIso8601String(), value);

      timerRef.value?.cancel();
      timerRef.value = Timer.periodic(const Duration(seconds: 1), tick);
    }

    String format(Duration d) {
      final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    }

    useEffect(() {
      startTimer();
      return () => timerRef.value?.cancel();
    }, []);

    return Column(
      children: [
        PrimaryButton(
          text: 'Отправить письмо повторно'.tr(),
          onPress: remaining.value.inSeconds == 0
              ? () {
                  onResend();
                  resetTimer();
                }
              : null,
        ),
        AppSpace.h16,
        Text(
          remaining.value.inSeconds == 0
              ? 'Не пришло письмо? Отправьте повторно'.tr()
              : 'Не пришло письмо? Повторно отправить через TIME сек'.tr(
                  namedArgs: {"time": format(remaining.value)},
                ),
          style: text_s12_w400_ls01.copyWith(color: palette.text60),
        ),
      ],
    );
  }
}
