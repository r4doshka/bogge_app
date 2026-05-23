import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/providers/navigation/routers/authorized/authorized_router.gr.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_border_radius.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/countdown_timer_circle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class WorkoutPrepareScreen extends ConsumerWidget {
  const WorkoutPrepareScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpace.ph16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: AppSpace.p12,
                    width: AppSpace.s52.spMin,
                    height: AppSpace.s52.spMin,
                    decoration: BoxDecoration(
                      color: palette.primary30,
                      borderRadius: AppBorderRadius.all100,
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/man-with-treadmill-icon.svg',
                    ),
                  ),
                  AppSpace.h24,
                  CountdownTimerCircle(
                    seconds: 3,
                    onFinished: () => context.router.replace(WorkoutRoute()),
                  ),
                  AppSpace.h24,
                  Text(
                    'Приготовьтесь!'.tr(),
                    style: text_s34_w700_ls04.copyWith(color: palette.text),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
