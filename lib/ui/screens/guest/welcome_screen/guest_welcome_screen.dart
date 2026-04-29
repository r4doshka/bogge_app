import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/widgets/banners/start_workout_banner.dart';
import 'package:bogge_app/ui/widgets/buttons/bluetooth_button.dart';
import 'package:bogge_app/ui/widgets/buttons/profile_button.dart';
import 'package:bogge_app/ui/widgets/empty_workouts.dart';
import 'package:bogge_app/ui/widgets/modals/empty_profile_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class GuestWelcomeScreen extends ConsumerWidget {
  const GuestWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpace.ph16,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BluetoothButton(),
                  ProfileButton(
                    onPress: () =>
                        showEmptyProfileModalBottom(context: context),
                  ),
                ],
              ),
              AppSpace.h16,
              StartWorkoutBanner(),
              SizedBox(height: 92.h),
              EmptyWorkouts(),
            ],
          ),
        ),
      ),
    );
  }
}
