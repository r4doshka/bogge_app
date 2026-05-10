import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/bluetooth/providers/ftms_provider.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/banners/start_workout_banner.dart';
import 'package:bogge_app/ui/widgets/buttons/bluetooth_button.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_button.dart';
import 'package:bogge_app/ui/widgets/buttons/profile_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpace.ph16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [BluetoothButton(), ProfileButton()],
              ),
              AppSpace.h16,
              StartWorkoutBanner(),
              AppSpace.h24,
              Text(
                'Тренировки'.tr(),
                style: text_s34_w700_ls04.copyWith(color: palette.text),
              ),
              // EmptyWorkouts(),
              PrimaryButton(
                text: 'start',
                onPress: () async {
                  await ref.read(ftmsProvider.notifier).requestControl();
                  await ref.read(ftmsProvider.notifier).start();
                  // await ref.read(ftmsProvider.notifier).setSpeed(3.0);
                  // await ref.read(ftmsProvider.notifier).stop();
                },
              ),
              PrimaryButton(
                text: 'stop',
                onPress: () async {
                  await ref.read(ftmsProvider.notifier).stop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
