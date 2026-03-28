import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ModalCloseButton extends StatelessWidget {
  final void Function()? onClose;
  final String? text;

  const ModalCloseButton({this.onClose, this.text, super.key});

  @override
  Widget build(context) {
    final buttonText = text ?? 'Close'.tr();

    return GestureDetector(
      onTap: () {
        if (onClose != null) {
          onClose!();
        }
        context.router.pop();
      },
      child: Padding(
        padding: EdgeInsetsDirectional.only(start: 16.w),
        child: Text(
          buttonText,
          // style: text_s14_w500.copyWith(color: palette.gray2),
        ),
      ),
    );
  }
}
