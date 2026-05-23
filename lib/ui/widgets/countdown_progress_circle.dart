import 'dart:ui';
import 'package:bogge_app/utils/color_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

class CountdownProgressCircle extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final double progress;
  final double pulseProgress;
  final Widget child;
  final Color activeColor;
  final Color inactiveColor;
  final Color pulseColor;

  const CountdownProgressCircle({
    super.key,
    required this.progress,
    required this.child,
    required this.activeColor,
    required this.inactiveColor,
    required this.pulseColor,
    this.pulseProgress = 0,
    this.size = 244,
    this.strokeWidth = 10,
  });

  @override
  Widget build(BuildContext context) {
    final currentSize = size.w;
    final currentStrokeWidth = strokeWidth.w;

    final maxPulseSize = currentSize * 1.48;
    final pulseValue = pulseProgress.clamp(0.0, 1.0);

    final waveSize = lerpDouble(currentSize, maxPulseSize, pulseValue)!;

    final opacity = (1 - pulseValue) * 0.28;

    return SizedBox(
      width: maxPulseSize,
      height: maxPulseSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (pulseValue > 0)
            Container(
              width: waveSize,
              height: waveSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: pulseColor.withSafeOpacity(opacity),
              ),
            ),

          SizedBox(
            width: currentSize,
            height: currentSize,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, _) {
                return CustomPaint(
                  painter: _CountdownCirclePainter(
                    progress: value,
                    strokeWidth: currentStrokeWidth,
                    activeColor: activeColor,
                    inactiveColor: inactiveColor,
                  ),
                  child: Center(child: child),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CountdownCirclePainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color activeColor;
  final Color inactiveColor;

  const _CountdownCirclePainter({
    required this.progress,
    required this.strokeWidth,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final inactivePaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect.deflate(strokeWidth / 2),
      -math.pi / 2,
      math.pi * 2,
      false,
      inactivePaint,
    );

    canvas.drawArc(
      rect.deflate(strokeWidth / 2),
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CountdownCirclePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
