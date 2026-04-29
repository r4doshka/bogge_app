import 'package:bogge_app/models/radio_button_model.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RadioButtonsGroup<T> extends StatelessWidget {
  final void Function(T value) onChange;
  final T? selectedValue;
  final List<RadioButtonModel<T>> options;

  const RadioButtonsGroup({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [];
    for (RadioButtonModel<T> option in options) {
      final isLast = options.last.value == option.value;
      final isFirst = options.first.value == option.value;

      widgets.add(
        RadioButton<T>(
          option: option,
          selectedValue: selectedValue,
          onChange: onChange,
          isLast: isLast,
          isFirst: isFirst,
        ),
      );
    }
    return Column(children: widgets);
  }
}

class RadioButton<T> extends ConsumerWidget {
  final void Function(T value) onChange;
  final T? selectedValue;
  final RadioButtonModel<T> option;
  final bool isLast;
  final bool isFirst;

  const RadioButton({
    super.key,
    required this.option,
    required this.selectedValue,
    required this.onChange,
    this.isLast = false,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);
    final isActive = selectedValue == option.value;

    return GestureDetector(
      onTap: () => onChange(option.value),
      child: Container(
        padding: AppSpace.ph16,
        decoration: BoxDecoration(
          color: palette.white,
          borderRadius: BorderRadius.only(
            topLeft: isFirst ? Radius.circular(26.r) : Radius.zero,
            topRight: isFirst ? Radius.circular(26.r) : Radius.zero,
            bottomLeft: isLast ? Radius.circular(26.r) : Radius.zero,
            bottomRight: isLast ? Radius.circular(26.r) : Radius.zero,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 21.spMin,
              height: 21.spMin,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.r),
                border: Border.all(
                  color: !isActive ? palette.gray3 : Colors.transparent,
                  width: 1.5.spMin,
                ),
                color: isActive ? palette.primary : Colors.transparent,
              ),
              child: Container(
                width: 11.spMin,
                height: 11.spMin,
                alignment: Alignment.center,
                child: isActive
                    ? SvgPicture.asset('assets/icons/radio-check-icon.svg')
                    : null,
              ),
            ),
            AppSpace.w16,
            Expanded(
              child: Container(
                padding: AppSpace.pv16,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.h, color: palette.gray),
                  ),
                ),
                child: Text(
                  option.label.tr(),
                  style: text_s17_w400_lsm043.copyWith(color: palette.text),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
