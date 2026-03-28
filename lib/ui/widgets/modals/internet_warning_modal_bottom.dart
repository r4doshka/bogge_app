import 'package:bogge_app/models/router/router_model.dart';
import 'package:bogge_app/ui/widgets/modals/widgets/default_modal_bottom.dart';
import 'package:bogge_app/utils/ui_tokens/app_space.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

Future<void> showInternetWarningModalBottom({
  required BuildContext context,
}) async {
  return await showDefaultModalBottom(
    context: context,
    isDismissible: false,
    hasCloseButton: false,
    modalName: AppModalList.internetWarning.title,
    child: Padding(
      padding: AppSpace.ph16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20.h),
          SvgPicture.asset(
            'assets/icons/no_internet.svg',
            width: 32.w,
            height: 32.w,
            matchTextDirection: true,
          ),
          SizedBox(height: 8.h),
          Text(
            'No internet connection'.tr(),
            // style: text_s24_w500.copyWith(color: AppPalette.white),
          ),
          SizedBox(height: 16.h),
          Text(
            "We can't load the page due to an unstable connection Check your internet connection"
                .tr(),
            // style: text_s14_w400.copyWith(color: AppPalette.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
