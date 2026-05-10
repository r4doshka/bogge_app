import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/palette.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:ui' as ui;

class WeightRulerPicker extends ConsumerStatefulWidget {
  final double initialValue;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const WeightRulerPicker({
    super.key,
    required this.initialValue,
    this.min = 30,
    this.max = 200,
    required this.onChanged,
  });

  @override
  ConsumerState<WeightRulerPicker> createState() => _WeightRulerPickerState();
}

class _WeightRulerPickerState extends ConsumerState<WeightRulerPicker> {
  static const double minorStepPx = WeightRulerConfig.minorStepPx;
  static const double valueStep = WeightRulerConfig.valueStep;

  late double value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue.clamp(widget.min, widget.max);
  }

  void _updateValue(double dx) {
    final deltaValue = -dx / minorStepPx * valueStep;
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

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragUpdate: (details) {
        _updateValue(details.delta.dx);
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final leftPadding = AppSpace.s4.w;
          final rightPadding = AppSpace.s4.w;

          final availableWidth =
              constraints.maxWidth - leftPadding - rightPadding;

          final indicatorX = leftPadding + availableWidth * 0.5;
          final rulerY = constraints.maxHeight;

          return Stack(
            children: [
              Positioned.fill(
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.transparent,
                        Colors.black,
                        Colors.black,
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.12, 0.88, 1.0],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstIn,
                  child: CustomPaint(
                    painter: WeightRulerPainter(
                      value: value,
                      min: widget.min,
                      max: widget.max,
                      palette: palette,
                      indicatorX: indicatorX,
                      rulerY: rulerY,
                      leftPadding: leftPadding,
                      rightPadding: rightPadding,
                    ),
                  ),
                ),
              ),

              Positioned(
                left: indicatorX,
                top: 0,
                bottom: constraints.maxHeight - rulerY,
                child: Container(width: AppSpace.s2.w, color: palette.primary),
              ),

              Positioned(
                left: indicatorX + AppSpace.s12.w,
                top: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(roundedValue, style: valueStyle),
                    AppSpace.w4,
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                        bottom: AppSpace.s8.h,
                      ),
                      child: Text(
                        'кг'.tr(),
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

class WeightRulerPainter extends CustomPainter {
  final double value;
  final double min;
  final double max;
  final AppPalette palette;
  final double indicatorX;
  final double rulerY;
  final double leftPadding;
  final double rightPadding;

  WeightRulerPainter({
    required this.value,
    required this.min,
    required this.max,
    required this.palette,
    required this.indicatorX,
    required this.rulerY,
    required this.leftPadding,
    required this.rightPadding,
  });

  static const double minorStepPx = WeightRulerConfig.minorStepPx;
  static const double valueStep = WeightRulerConfig.valueStep;

  @override
  void paint(Canvas canvas, Size size) {
    final minorPaint = Paint()
      ..color = palette.text30
      ..strokeWidth = 1;

    final majorPaint = Paint()
      ..color = palette.text
      ..strokeWidth = 1;

    final textPainter = TextPainter(textDirection: ui.TextDirection.ltr);

    final startIndex = ((min - value) / valueStep).floor() - 20;
    final endIndex = ((max - value) / valueStep).ceil() + 20;

    for (int i = startIndex; i <= endIndex; i++) {
      final currentValue = value + i * valueStep;

      if (currentValue < min || currentValue > max) continue;

      final x = indicatorX + i * minorStepPx;

      if (x < leftPadding || x > size.width - rightPadding) continue;

      final isMajor = (currentValue * 10).round() % 10 == 0;

      final lineHeight = isMajor ? AppSpace.s40 : AppSpace.s24;
      final paint = isMajor ? majorPaint : minorPaint;

      canvas.drawLine(Offset(x, rulerY), Offset(x, rulerY - lineHeight), paint);

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
          Offset(
            x - textPainter.width / 2,
            rulerY - lineHeight - textPainter.height,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant WeightRulerPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.min != min ||
        oldDelegate.max != max ||
        oldDelegate.indicatorX != indicatorX ||
        oldDelegate.rulerY != rulerY ||
        oldDelegate.leftPadding != leftPadding ||
        oldDelegate.rightPadding != rightPadding ||
        oldDelegate.palette != palette;
  }
}

class WeightRulerConfig {
  static const double minorStepPx = AppSpace.s8;
  static const double valueStep = 0.1;
}
