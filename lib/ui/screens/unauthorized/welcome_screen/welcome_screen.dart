import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/providers/navigation/routers/un_authorized/un_authorized_router.gr.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_button.dart';
import 'package:bogge_app/ui/widgets/buttons/secondary_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            PositionedDirectional(
              top: 0,
              end: 0,
              bottom: 0,
              start: 0,
              child: Image.asset(
                'assets/images/welcome-image.png',
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: AppSpace.s34.w,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SvgPicture.asset(
                    'assets/icons/logo-icon.svg',
                    width: 262.w,
                    height: 71.h,
                  ),
                  AppSpace.h14,
                  Text(
                    'Твой ритм движения'.tr(),
                    style: text_s17_w600_lsm043.copyWith(
                      color: palette.white60,
                    ),
                  ),
                  SizedBox(height: 170.h),
                  PrimaryButton(
                    text: 'Создать учетную запись'.tr(),
                    onPress: () => context.router.push(SignUpRoute()),
                  ),
                  AppSpace.h8,
                  SecondaryButton(
                    text: 'Войти'.tr(),
                    onPress: () => context.router.push(SignInRoute()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
