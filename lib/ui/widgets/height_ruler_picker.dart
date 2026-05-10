import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/palette.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/utils/measure_text_height.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:ui' as ui;

class HeightRulerPicker extends ConsumerStatefulWidget {
  final double initialValue;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const HeightRulerPicker({
    super.key,
    required this.initialValue,
    this.min = 100,
    this.max = 240,
    required this.onChanged,
  });

  @override
  ConsumerState<HeightRulerPicker> createState() => _HeightRulerPickerState();
}

class _HeightRulerPickerState extends ConsumerState<HeightRulerPicker> {
  static const double minorStepPx = HeightRulerConfig.minorStepPx;
  static const double valueStep = HeightRulerConfig.valueStep;

  late double value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue.clamp(widget.min, widget.max);
  }

  void _updateValue(double dy) {
    final deltaValue = -dy / minorStepPx * valueStep;

    final newValue = (value + deltaValue).clamp(widget.min, widget.max);

    setState(() {
      value = newValue;
    });

    widget.onChanged(double.parse(value.toStringAsFixed(1)));
  }

  @override
  Widget build(BuildContext context) {
    final palette = ref.read(paletteProvider);
    final roundedValue = value.toStringAsFixed(1);
    final valueStyle = text_s48_w600_lsm043.copyWith(color: palette.text);
    final valueHeight = measureTextHeight(roundedValue, valueStyle);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: (details) {
        _updateValue(details.delta.dy);
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final topPadding = AppSpace.s8.h;
          final bottomPadding = AppSpace.s8.h;

          final availableHeight =
              constraints.maxHeight - topPadding - bottomPadding;
          final indicatorY = topPadding + availableHeight * 0.45;

          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black,
                        Colors.black,
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.1, 0.9, 1.0],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstIn,
                  child: CustomPaint(
                    painter: HeightRulerPainter(
                      value: value,
                      min: widget.min,
                      max: widget.max,
                      palette: palette,
                      indicatorY: indicatorY,
                      topPadding: topPadding,
                      bottomPadding: bottomPadding,
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 0,
                right: 130.w,
                top: indicatorY,
                child: Container(height: AppSpace.s2.h, color: palette.primary),
              ),

              Positioned(
                left: 0,
                right: 130.w,
                top: indicatorY - valueHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      roundedValue,
                      style: text_s48_w600_lsm043.copyWith(color: palette.text),
                    ),
                    AppSpace.w4,
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                        bottom: AppSpace.s8.h,
                      ),
                      child: Text(
                        'см'.tr(),
                        style: text_s17_w500_lsm043.copyWith(
                          color: palette.text,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class HeightRulerPainter extends CustomPainter {
  final double value;
  final double min;
  final double max;
  final AppPalette palette;
  final double indicatorY;
  final double topPadding;
  final double bottomPadding;

  HeightRulerPainter({
    required this.value,
    required this.min,
    required this.max,
    required this.palette,
    required this.indicatorY,
    required this.topPadding,
    required this.bottomPadding,
  });

  static const double minorStepPx = HeightRulerConfig.minorStepPx;
  static const double valueStep = HeightRulerConfig.valueStep;

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = indicatorY;

    final minorPaint = Paint()
      ..color = palette.text30
      ..strokeWidth = 1;

    final majorPaint = Paint()
      ..color = palette.text
      ..strokeWidth = 1.4;

    final textPainter = TextPainter(textDirection: ui.TextDirection.ltr);

    final startIndex = ((min - value) / valueStep).floor() - 20;
    final endIndex = ((max - value) / valueStep).ceil() + 20;

    for (int i = startIndex; i <= endIndex; i++) {
      final currentValue = value + i * valueStep;

      if (currentValue < min || currentValue > max) continue;

      final y = centerY - i * minorStepPx;

      if (y < topPadding || y > size.height - bottomPadding) continue;

      final isMajor = (currentValue * 10).round() % 10 == 0;

      final lineLength = isMajor ? AppSpace.s40 : AppSpace.s24;

      final paint = isMajor ? majorPaint : minorPaint;

      canvas.drawLine(Offset(0, y), Offset(lineLength, y), paint);

      if (isMajor) {
        final intLabel = currentValue.round().toString();

        textPainter.text = TextSpan(
          text: intLabel,
          style: text_s17_w500_lsm043.copyWith(
            color: currentValue.round() == value.round()
                ? palette.text
                : palette.text30,
          ),
        );

        textPainter.layout();

        textPainter.paint(
          canvas,
          Offset(lineLength + AppSpace.s8, y - textPainter.height / 2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant HeightRulerPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.min != min ||
        oldDelegate.max != max ||
        oldDelegate.indicatorY != indicatorY ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.bottomPadding != bottomPadding ||
        oldDelegate.palette != palette;
  }
}

class HeightRulerConfig {
  static const double minorStepPx = AppSpace.s8;
  static const double valueStep = 0.1;
}
