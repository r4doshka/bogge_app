import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/providers/navigation/routers/un_authorized/un_authorized_router.gr.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_icon_button.dart';
import 'package:bogge_app/utils/get_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CommonHeader extends ConsumerWidget {
  final double? paddingTop;
  final void Function()? onPop;
  final PageRouteInfo? backRoute;
  final String? title;

  const CommonHeader({
    this.paddingTop,
    this.title,
    this.onPop,
    this.backRoute,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);

    return Container(
      padding: EdgeInsetsDirectional.only(
        top: paddingTop ?? getPaddingTop(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PrimaryIconButton(
                svgPath: 'assets/icons/chevron-left-icon.svg',
                iconWidth: AppSpace.s12.w,
                iconHeight: 18.h,
                containerHeight: AppSpace.s44.w,
                containerWidth: AppSpace.s44.w,
                backgroundColor: palette.primary12,
                onPress: () {
                  if (onPop != null) {
                    onPop!();
                    return;
                  }
                  final router = AutoRouter.of(context);

                  if (router.canPop()) {
                    router.pop();
                  } else if (backRoute != null) {
                    context.router.push(backRoute!);
                  } else {
                    router.replaceAll([const SignInRoute()]);
                  }
                },
              ),
            ],
          ),
          if (title != null) ...[
            AppSpace.h16,
            Text(
              title!,
              style: text_s34_w700_ls04.copyWith(color: palette.text),
            ),
          ],
        ],
      ),
    );
  }
}
