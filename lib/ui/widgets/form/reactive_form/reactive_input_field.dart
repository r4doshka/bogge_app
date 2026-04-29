import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_border_radius.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ReactiveInputField<T> extends HookConsumerWidget {
  final String fieldName;
  final Widget? hint;
  final double? containerHeight;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final String? labelText;
  final TextStyle? labelStyle;
  final EdgeInsetsDirectional? contentPadding;
  final Color? inputColor;
  final List<TextInputFormatter>? inputFormatters;
  final Map<String, String Function(Object)>? validationMessages;
  final TextInputType? keyboardType;
  final ControlValueAccessor<T, String>? valueAccessor;
  final void Function(FormControl<T>)? onChanged;
  final bool obscureText;
  final List<String>? hiddenErrors;

  const ReactiveInputField({
    required this.fieldName,
    this.hint,
    this.containerHeight,
    this.hintText,
    this.hintStyle,
    this.textStyle,
    this.contentPadding,
    this.inputColor,
    this.inputFormatters,
    this.validationMessages,
    this.keyboardType,
    this.valueAccessor,
    this.onChanged,
    this.labelText,
    this.labelStyle,
    this.obscureText = false,
    this.hiddenErrors,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);

    final focusNode = useFocusNode();
    final isFocused = useState(false);

    useEffect(() {
      void listener() {
        isFocused.value = focusNode.hasFocus;
      }

      focusNode.addListener(listener);

      return () => focusNode.removeListener(listener);
    }, [focusNode]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReactiveFormField(
          formControlName: fieldName,
          builder: (field) {
            final control = field.control;
            final hasValue =
                control.value != null && control.value.toString().isNotEmpty;

            final isActive = isFocused.value || hasValue;

            final hasErrors =
                control.invalid && (control.touched || control.dirty);

            return AnimatedContainer(
              height: containerHeight ?? 54.h,
              duration: const Duration(milliseconds: 150),
              padding: EdgeInsetsDirectional.only(
                start: AppSpace.s16.w,
                end: AppSpace.s16.w,
                top: isActive ? AppSpace.s4.h : AppSpace.s8.h,
                bottom: isActive ? AppSpace.s20.h : AppSpace.s8.h,
              ),
              decoration: BoxDecoration(
                color: inputColor ?? palette.white,
                borderRadius: AppBorderRadius.all16,
              ),
              child: ReactiveTextField<T>(
                formControlName: fieldName,
                focusNode: focusNode,
                onChanged: onChanged,
                obscureText: obscureText,
                obscuringCharacter: '*',
                showErrors: (control) => false,
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  hint: hint,
                  hintText: hintText,
                  hintStyle:
                      hintStyle ??
                      text_s17_w400_lsm043.copyWith(color: palette.text30),
                  contentPadding: contentPadding ?? EdgeInsetsDirectional.zero,
                  filled: false,
                  fillColor: Colors.transparent,
                  errorText: null,
                  errorStyle: const TextStyle(
                    height: 0,
                    fontSize: 0,
                    color: Colors.transparent,
                  ),
                  floatingLabelStyle: text_s11_w400_ls01.copyWith(
                    color: palette.text30,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelText: labelText,
                  labelStyle:
                      labelStyle ??
                      text_s17_w500_lsm043.copyWith(color: palette.text30),
                ),
                style:
                    textStyle ??
                    text_s17_w500_lsm043.copyWith(
                      color: hasErrors ? palette.peach : palette.text,
                      letterSpacing: obscureText
                          ? 0
                          : text_s17_w500_lsm043.letterSpacing,
                    ),
                cursorColor: palette.primary,
                keyboardType: keyboardType ?? TextInputType.text,
                valueAccessor: valueAccessor,
                inputFormatters: inputFormatters,
                validationMessages: validationMessages,
              ),
            );
          },
        ),
        AppSpace.h4,
        ReactiveValueListenableBuilder(
          formControlName: fieldName,
          builder: (context, control, _) {
            if (control.invalid && (control.touched || control.dirty)) {
              final entries = control.errors.entries.where(
                (e) => !(hiddenErrors?.contains(e.key) ?? false),
              );

              final List<String> errorTexts = entries
                  .map((entry) {
                    final key = entry.key;
                    final value = entry.value;

                    final customBuilder = validationMessages?[key];
                    if (customBuilder != null) {
                      return customBuilder(value);
                    }

                    return value.toString();
                  })
                  .where((msg) => msg.isNotEmpty)
                  .toList();

              if (errorTexts.isEmpty) return const SizedBox();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final msg in errorTexts)
                    Text(
                      msg,
                      style: text_s11_w400_lsm043.copyWith(
                        color: palette.peach,
                      ),
                    ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
