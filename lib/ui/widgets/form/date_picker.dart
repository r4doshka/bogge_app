import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_border_radius.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/palette.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/animations/rotate_container.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:string_extensions/string_extensions.dart';

class DatePicker extends HookConsumerWidget {
  final void Function(List<DateTime?>) onValueChanged;
  final List<DateTime?> initialValue;

  const DatePicker({
    super.key,
    required this.onValueChanged,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);
    final displayedMonth = useState<DateTime>(DateTime.now());
    final date = useState<List<DateTime?>>(initialValue);

    return Container(
      decoration: BoxDecoration(
        color: palette.white,
        borderRadius: AppBorderRadius.all16,
      ),
      child: CalendarDatePicker2(
        value: date.value,
        config: CalendarDatePicker2Config(
          lastDate: DateTime(2025, 12, 31),
          firstDate: DateTime(1920, 1, 1),
          centerAlignModePicker: false,
          firstDayOfWeek: 1,
          hideYearPickerDividers: true,
          hideMonthPickerDividers: true,
          calendarType: CalendarDatePicker2Type.single,
          dayMaxWidth: AppSpace.s44.w,
          yearBuilder:
              ({
                BoxDecoration? decoration,
                bool? isCurrentYear,
                bool? isDisabled,
                bool? isSelected,
                required int year,
                TextStyle? textStyle,
              }) {
                Color bgColor = Colors.transparent;
                Color textColor = palette.text;

                if (isCurrentYear == true) {
                  bgColor = palette.primary12;
                }

                if (isDisabled == true) {
                  textColor = palette.text30;
                }

                final isDisplayedYear = displayedMonth.value.year == year;

                if (isDisplayedYear) {
                  bgColor = palette.primary12;
                  textColor = palette.text;
                }

                return Container(
                  alignment: Alignment.center,
                  height: AppSpace.s44.h,
                  margin: EdgeInsetsDirectional.symmetric(
                    vertical: AppSpace.s4.h,
                  ),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: AppBorderRadius.all24,
                  ),
                  child: Text(
                    year.toString(),
                    style: text_s17_w400_lsm043.copyWith(color: textColor),
                  ),
                );
              },
          monthBuilder:
              ({
                BoxDecoration? decoration,
                bool? isCurrentMonth,
                bool? isDisabled,
                bool? isSelected,
                required int month,
                TextStyle? textStyle,
              }) {
                final locale = Localizations.localeOf(context).toString();

                Color bgColor = Colors.transparent;
                Color textColor = palette.text;

                if (isCurrentMonth == true) {
                  bgColor = palette.primary12;
                }

                if (isDisabled == true) {
                  textColor = palette.text30;
                }

                final isDisplayedMonth = displayedMonth.value.month == month;

                if (isDisplayedMonth) {
                  bgColor = palette.primary12;
                  textColor = palette.text;
                }

                return Container(
                  alignment: Alignment.center,
                  height: AppSpace.s44.h,
                  margin: EdgeInsetsDirectional.symmetric(
                    vertical: AppSpace.s4.h,
                  ),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: AppBorderRadius.all32,
                  ),
                  child: Text(
                    DateFormat.MMM(locale).format(DateTime(2021, month)),
                    style: text_s17_w400_lsm043.copyWith(color: textColor),
                  ),
                );
              },
          dayTextStyle: text_s17_w400_lsm043.copyWith(color: palette.text),
          selectedDayTextStyle: text_s17_w400_lsm043.copyWith(
            color: palette.primary,
          ),
          todayTextStyle: text_s17_w400_lsm043.copyWith(color: palette.primary),
          disabledDayTextStyle: text_s17_w400_lsm043.copyWith(
            color: palette.text30,
          ),
          dayBuilder:
              ({
                required DateTime date,
                BoxDecoration? decoration,
                bool? isDisabled,
                bool? isSelected,
                bool? isToday,
                TextStyle? textStyle,
              }) {
                Color textColor = palette.text;
                FontWeight fontWeight = FontWeight.w400;
                BoxDecoration? finalDecoration = decoration;

                if (isSelected == true) {
                  textColor = palette.primary;
                  fontWeight = FontWeight.w700;
                  finalDecoration = BoxDecoration(
                    color: palette.primary12,
                    borderRadius: AppBorderRadius.all100,
                  );
                } else if (isDisabled == true) {
                  textColor = palette.primary12;
                }

                if (isToday == true && isSelected != true) {
                  finalDecoration = BoxDecoration(
                    color: palette.primary,
                    borderRadius: AppBorderRadius.all100,
                  );
                }
                return Container(
                  alignment: Alignment.center,
                  decoration: finalDecoration,
                  child: Text(
                    '${date.day}',
                    style: text_s17_w400_lsm043.copyWith(
                      color: textColor,
                      fontWeight: fontWeight,
                    ),
                  ),
                );
              },
          modePickerBuilder:
              ({
                bool? isMonthPicker,
                required DateTime monthDate,
                required CalendarDatePicker2Mode viewMode,
              }) {
                final locale = Localizations.localeOf(context).toString();
                final month = DateFormat.MMMM(locale).format(monthDate);
                final year = DateFormat.y(locale).format(monthDate);
                final text = isMonthPicker == true ? month : year;

                final isMonthOpened = viewMode == CalendarDatePicker2Mode.month;
                final isYearOpened = viewMode == CalendarDatePicker2Mode.year;
                final isDay = viewMode == CalendarDatePicker2Mode.day;
                final isOpened = isMonthPicker == true
                    ? isMonthOpened
                    : isYearOpened;

                if (!isDay) {
                  if (isMonthPicker == true && !isMonthOpened) {
                    return const SizedBox.shrink();
                  }
                  if (isMonthPicker != true && !isYearOpened) {
                    return const SizedBox.shrink();
                  }
                }
                return Padding(
                  padding: EdgeInsetsDirectional.only(
                    end: isMonthPicker == true ? AppSpace.s8.w : 0,
                  ),

                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        text.toTitleCase,
                        style: text_s17_w700_lsm043.copyWith(
                          color: palette.text,
                        ),
                      ),
                      AppSpace.w8,
                      RotateContainer(
                        value: isOpened,
                        end: 0.75,
                        begin: 0.25,
                        child: SvgPicture.asset(
                          'assets/icons/chevron-right-icon.svg',
                          width: 6.w,
                          height: 10.h,
                          colorFilter: ColorFilter.mode(
                            palette.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
          lastMonthIcon: _buildMonthIcon(isLeft: true, palette: palette),
          nextMonthIcon: _buildMonthIcon(palette: palette),
          weekdayLabelBuilder:
              ({bool? isScrollViewTopHeader, required int weekday}) =>
                  _weekdayLabelBuilder(
                    isScrollViewTopHeader: isScrollViewTopHeader,
                    weekday: weekday,
                    context: context,
                    palette: palette,
                  ),
        ),

        onDisplayedMonthChanged: (val) {
          displayedMonth.value = val;
        },
        onValueChanged: (val) {
          date.value = val;
          onValueChanged(val);
        },
      ),
    );
  }

  Widget _buildMonthIcon({bool isLeft = false, required AppPalette palette}) {
    final asset = isLeft
        ? 'assets/icons/chevron-left-icon.svg'
        : 'assets/icons/chevron-right-icon.svg';
    return SvgPicture.asset(
      asset,
      width: 10,
      height: 18,
      matchTextDirection: true,
      colorFilter: ColorFilter.mode(palette.primary, BlendMode.srcIn),
    );
  }

  Widget _weekdayLabelBuilder({
    bool? isScrollViewTopHeader,
    required int weekday,
    required BuildContext context,
    required AppPalette palette,
  }) {
    final baseDate = DateTime(2021, 1, 4);
    final date = baseDate.add(Duration(days: weekday - 1));

    final label = DateFormat.E(context.locale.languageCode).format(date);

    return Container(
      alignment: Alignment.center,
      child: Text(
        label.toUpperCase(),
        style: text_s14_w600_lsm043.copyWith(color: palette.text12),
      ),
    );
  }

  bool isSameColor(Color? a, Color b) {
    if (a == null) return false;
    return a.toARGB32() == b.toARGB32();
  }
}
