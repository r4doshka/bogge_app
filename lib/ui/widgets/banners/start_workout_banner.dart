import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/ftms/providers/ftms_provider.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_border_radius.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_button.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:bogge_app/providers/navigation/routers/authorized/authorized_router.gr.dart';

class StartWorkoutBanner extends HookConsumerWidget {
  const StartWorkoutBanner({super.key});

  Future<void> handleStartWorkout(BuildContext context, WidgetRef ref) async {
    if (!context.mounted) return;

    await ref.read(ftmsProvider.notifier).startDeviceFlow(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);
    final state = ref.watch(ftmsProvider);

    final isActive = state.connectionStatus == ConnectionStatus.connected;

    final shouldNavigateAfterConnect = useState(false);

    ref.listen<ConnectionStatus>(
      ftmsProvider.select((s) => s.connectionStatus),
      (previous, next) {
        if (!shouldNavigateAfterConnect.value) return;

        if (next == ConnectionStatus.connected) {
          shouldNavigateAfterConnect.value = false;

          if (context.mounted) {
            context.router.push(WorkoutPrepareRoute());
          }
        }

        if (next == ConnectionStatus.error ||
            next == ConnectionStatus.disconnected) {
          shouldNavigateAfterConnect.value = false;
        }
      },
    );

    return Stack(
      children: [
        PositionedDirectional(
          top: 0,
          end: 0,
          bottom: 0,
          start: 0,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/start-banner-image.png'),
                fit: BoxFit.fill,
              ),
              borderRadius: AppBorderRadius.all32,
              border: Border.all(width: 2, color: palette.white30),
            ),
          ),
        ),
        Row(
          children: [
            SizedBox(width: 14.w),
            SizedBox(
              width: 230.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 79.h),
                  Text(
                    'Время двигаться'.tr(),
                    style: text_s17_w700_lsm043.copyWith(
                      color: palette.primary,
                    ),
                    maxLines: 1,
                  ),
                  Text(
                    'Подключите дорожку и начните бег'.tr(),
                    style: text_s13_w400_lsm043.copyWith(color: palette.text),
                    maxLines: 1,
                  ),
                  AppSpace.h8,
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: AppSpace.s12.w),
                    child: PrimaryButton(
                      text: 'Начать тренировку'.tr(),
                      renderLeftIcon: () => Padding(
                        padding: EdgeInsetsDirectional.only(end: 5.5.w),
                        child: SvgPicture.asset(
                          'assets/icons/play-small-icon.svg',
                          width: AppSpace.s12.w,
                          height: 14.h,
                        ),
                      ),
                      onPress: () async {
                        if (isActive) {
                          context.router.push(WorkoutPrepareRoute());
                          return;
                        }

                        shouldNavigateAfterConnect.value = true;

                        await handleStartWorkout(context, ref);
                      },
                    ),
                  ),
                  SizedBox(height: 14.h),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
