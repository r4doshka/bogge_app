import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_border_radius.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PinCodeFields extends ConsumerStatefulWidget {
  final PinInputController controller;
  final void Function(String)? onComplete;
  final void Function(String)? onChanged;
  final String? errorText;

  const PinCodeFields({
    required this.controller,
    this.onComplete,
    this.onChanged,
    this.errorText,
    super.key,
  });

  @override
  ConsumerState<PinCodeFields> createState() => _PinCodeFieldsState();
}

class _PinCodeFieldsState extends ConsumerState<PinCodeFields> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final palette = ref.watch(paletteProvider);
    final width = MediaQuery.of(context).size.width - AppSpace.s32.w;
    final spacing = AppSpace.s8.w;
    final cellWidth = (width - spacing * 5) / 6;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Form(
          key: formKey,
          child: MaterialPinField(
            theme: MaterialPinTheme(
              borderWidth: 0,
              focusedBorderWidth: 0,
              focusedBorderColor: palette.white,
              followingBorderColor: palette.white,
              filledBorderColor: palette.white,
              errorBorderColor: palette.white,
              borderColor: palette.white,
              shape: MaterialPinShape.outlined,
              cellSize: Size(cellWidth, 54.h),
              spacing: spacing,
              borderRadius: AppBorderRadius.all24.r,
              textStyle: text_s17_w400_lsm043.copyWith(color: palette.text),
              errorTextStyle: text_s17_w400_lsm043.copyWith(
                color: palette.peach,
              ),
              fillColor: palette.white,
              focusedFillColor: palette.white,
              followingFillColor: palette.white,
              filledFillColor: palette.white,
              errorFillColor: palette.white,
              enableErrorShake: true,
              cursorColor: palette.primary,
            ),
            length: 6,
            scrollPadding: EdgeInsets.zero,
            pinController: widget.controller,
            keyboardType: TextInputType.number,
            keyboardAppearance: Brightness.dark,
            textInputAction: TextInputAction.done,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            clearErrorOnInput: true,
            enablePaste: false,
            autofillHints: const [AutofillHints.oneTimeCode],
            errorText: widget.errorText,
            onChanged: widget.onChanged,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            errorBuilder: (errorText) {
              if (errorText != null) {
                return Column(
                  children: [
                    AppSpace.h8,
                    Text(
                      errorText,
                      style: text_s14_w400_ls01.copyWith(color: palette.peach),
                    ),
                  ],
                );
              }
              return SizedBox();
            },
            onCompleted: widget.onComplete,
          ),
        ),
      ],
    );
  }
}
