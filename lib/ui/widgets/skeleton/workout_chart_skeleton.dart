import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class WorkoutFullChartSkeleton extends HookWidget {
  const WorkoutFullChartSkeleton({super.key});

  static const double _viewBoxWidth = 339;
  static const double _viewBoxHeight = 145;

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 1400),
    );

    useEffect(() {
      controller.repeat();
      return null;
    }, [controller]);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = width * _viewBoxHeight / _viewBoxWidth;

        return SizedBox(
          width: double.infinity,
          height: height,
          child: AnimatedBuilder(
            animation: controller,
            builder: (_, _) {
              return CustomPaint(
                painter: _WorkoutFullChartSkeletonPainter(
                  progress: controller.value,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _WorkoutFullChartSkeletonPainter extends CustomPainter {
  final double progress;

  _WorkoutFullChartSkeletonPainter({required this.progress});

  static const Color _gridColor = Color(0xFFE7E6E6);
  static const Color _labelColor = Color(0xFFD6D3D3);
  static const Color _chartColor = Color(0xFFD9D9D9);

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 339;
    final sy = size.height / 121;

    Offset p(double x, double y) => Offset(x * sx, y * sy);

    canvas.saveLayer(Offset.zero & size, Paint());

    _drawGrid(canvas, p, sx);
    _drawLabels(canvas, p, sx, sy);
    _drawChart(canvas, size);
    _drawShimmer(canvas, size);

    canvas.restore();
  }

  void _drawGrid(
    Canvas canvas,
    Offset Function(double x, double y) p,
    double sx,
  ) {
    final gridPaint = Paint()
      ..color = _gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 * sx;

    canvas.drawLine(p(0.5, 9), p(303.5, 9), gridPaint);
    canvas.drawLine(p(0.5, 57), p(303.5, 57), gridPaint);
    canvas.drawLine(p(0.5, 105), p(303.5, 105), gridPaint);

    for (final x in [0.5, 76.25, 152.0, 227.75, 303.5]) {
      _drawDashedLine(canvas, p(x, 9), p(x, 121), gridPaint);
    }
  }

  void _drawLabels(
    Canvas canvas,
    Offset Function(double x, double y) p,
    double sx,
    double sy,
  ) {
    _drawLabelBone(
      canvas,
      Rect.fromLTWH(p(3, 109).dx, p(3, 109).dy, 18 * sx, 8 * sy),
    );

    _drawLabelBone(
      canvas,
      Rect.fromLTWH(p(79, 109).dx, p(79, 109).dy, 18 * sx, 8 * sy),
    );

    _drawLabelBone(
      canvas,
      Rect.fromLTWH(p(154, 109).dx, p(154, 109).dy, 18 * sx, 8 * sy),
    );

    _drawLabelBone(
      canvas,
      Rect.fromLTWH(p(230, 109).dx, p(230, 109).dy, 18 * sx, 8 * sy),
    );

    _drawLabelBone(
      canvas,
      Rect.fromLTWH(p(309, 5).dx, p(309, 5).dy, 22 * sx, 8 * sy),
    );

    _drawLabelBone(
      canvas,
      Rect.fromLTWH(p(309, 53).dx, p(309, 53).dy, 22 * sx, 8 * sy),
    );

    _drawLabelBone(
      canvas,
      Rect.fromLTWH(p(309, 101).dx, p(309, 101).dy, 12 * sx, 8 * sy),
    );
  }

  void _drawLabelBone(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = _labelColor
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(3)),
      paint,
    );
  }

  void _drawChart(Canvas canvas, Size size) {
    final path = _WorkoutChartPath.build(size);

    final chartBounds = Rect.fromLTWH(
      0,
      0,
      size.width * 303.5 / 339,
      size.height * 105 / 121,
    );

    canvas.save();
    canvas.clipRect(chartBounds);

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [_chartColor.withOpacity(0.70), _chartColor.withOpacity(0.05)],
      ).createShader(chartBounds);

    final strokePaint = Paint()
      ..color = _chartColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);

    canvas.restore();
  }

  void _drawShimmer(Canvas canvas, Size size) {
    final shimmerWidth = size.width * 0.45;
    final dx = (size.width + shimmerWidth * 2) * progress - shimmerWidth;

    final shimmerRect = Rect.fromLTWH(
      dx - shimmerWidth,
      0,
      shimmerWidth * 2,
      size.height,
    );

    final shimmerPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.transparent,
          Colors.white.withOpacity(0.65),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(shimmerRect)
      ..blendMode = BlendMode.srcATop;

    canvas.drawRect(Offset.zero & size, shimmerPaint);
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 3.0;
    const dashSpace = 3.0;

    final distance = (end - start).distance;
    final direction = (end - start) / distance;

    double current = 0;

    while (current < distance) {
      final from = start + direction * current;
      final to = start + direction * (current + dashWidth).clamp(0, distance);
      canvas.drawLine(from, to, paint);
      current += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _WorkoutFullChartSkeletonPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

abstract class _WorkoutChartPath {
  static Path build(Size size) {
    final sx = size.width / 339;
    final sy = size.height / 121;

    Offset p(double x, double y) => Offset(x * sx, y * sy);

    return Path()
      ..moveTo(p(294.292, 102.388).dx, p(294.292, 102.388).dy)
      ..lineTo(p(303.654, 105).dx, p(303.654, 105).dy)
      ..lineTo(p(-58.3457, 105).dx, p(-58.3457, 105).dy)
      ..lineTo(p(-58.3457, 26.6327).dx, p(-58.3457, 26.6327).dy)
      ..lineTo(p(-46.9032, 30.2245).dx, p(-46.9032, 30.2245).dy)
      ..lineTo(p(-34.4204, 34.4694).dx, p(-34.4204, 34.4694).dy)
      ..lineTo(p(-28.179, 39.0408).dx, p(-28.179, 39.0408).dy)
      ..lineTo(p(-24.0181, 44.9184).dx, p(-24.0181, 44.9184).dy)
      ..lineTo(p(-19.8572, 52.7551).dx, p(-19.8572, 52.7551).dy)
      ..lineTo(p(-0.0928307, 55.3674).dx, p(-0.0928307, 55.3674).dy)
      ..lineTo(p(8.22901, 63.2041).dx, p(8.22901, 63.2041).dy)
      ..lineTo(p(17.5911, 67.7755).dx, p(17.5911, 67.7755).dy)
      ..lineTo(p(25.9129, 64.8367).dx, p(25.9129, 64.8367).dy)
      ..lineTo(p(40.4761, 60.2653).dx, p(40.4761, 60.2653).dy)
      ..lineTo(p(44.6371, 53.4082).dx, p(44.6371, 53.4082).dy)
      ..lineTo(p(49.8382, 46.8776).dx, p(49.8382, 46.8776).dy)
      ..lineTo(p(58.16, 42.9592).dx, p(58.16, 42.9592).dy)
      ..lineTo(p(61.2807, 34.4694).dx, p(61.2807, 34.4694).dy)
      ..lineTo(p(69.6026, 25.6531).dx, p(69.6026, 25.6531).dy)
      ..lineTo(p(72.7233, 20.102).dx, p(72.7233, 20.102).dy)
      ..lineTo(p(81.0451, 15.2041).dx, p(81.0451, 15.2041).dy)
      ..lineTo(p(87.2865, 11.9388).dx, p(87.2865, 11.9388).dy)
      ..lineTo(p(93.5279, 9).dx, p(93.5279, 9).dy)
      ..lineTo(p(103.93, 13.2449).dx, p(103.93, 13.2449).dy)
      ..lineTo(p(106.011, 29.2449).dx, p(106.011, 29.2449).dy)
      ..lineTo(p(116.413, 34.4694).dx, p(116.413, 34.4694).dy)
      ..lineTo(p(122.654, 33.4898).dx, p(122.654, 33.4898).dy)
      ..lineTo(p(133.057, 28.2653).dx, p(133.057, 28.2653).dy)
      ..lineTo(p(140.338, 23.6939).dx, p(140.338, 23.6939).dy)
      ..lineTo(p(143.459, 15.2041).dx, p(143.459, 15.2041).dy)
      ..lineTo(p(150.741, 15.2041).dx, p(150.741, 15.2041).dy)
      ..lineTo(p(161.143, 15.2041).dx, p(161.143, 15.2041).dy)
      ..lineTo(p(170.505, 17.8163).dx, p(170.505, 17.8163).dy)
      ..lineTo(p(170.505, 22.3878).dx, p(170.505, 22.3878).dy)
      ..lineTo(p(174.666, 27.6122).dx, p(174.666, 27.6122).dy)
      ..lineTo(p(181.947, 30.8776).dx, p(181.947, 30.8776).dy)
      ..lineTo(p(185.068, 32.8367).dx, p(185.068, 32.8367).dy)
      ..lineTo(p(192.35, 30.8776).dx, p(192.35, 30.8776).dy)
      ..lineTo(p(196.511, 28.2653).dx, p(196.511, 28.2653).dy)
      ..lineTo(p(199.631, 23.6939).dx, p(199.631, 23.6939).dy)
      ..lineTo(p(208.993, 20.102).dx, p(208.993, 20.102).dy)
      ..lineTo(p(227.718, 23.6939).dx, p(227.718, 23.6939).dy)
      ..lineTo(p(236.039, 25.6531).dx, p(236.039, 25.6531).dy)
      ..lineTo(p(236.039, 30.8776).dx, p(236.039, 30.8776).dy)
      ..lineTo(p(236.039, 38.0612).dx, p(236.039, 38.0612).dy)
      ..lineTo(p(236.039, 46.8776).dx, p(236.039, 46.8776).dy)
      ..lineTo(p(236.039, 50.7959).dx, p(236.039, 50.7959).dy)
      ..lineTo(p(240.2, 55.3674).dx, p(240.2, 55.3674).dy)
      ..lineTo(p(240.2, 58.3061).dx, p(240.2, 58.3061).dy)
      ..lineTo(p(240.2, 61.5714).dx, p(240.2, 61.5714).dy)
      ..lineTo(p(240.2, 63.8572).dx, p(240.2, 63.8572).dy)
      ..lineTo(p(244.361, 66.7959).dx, p(244.361, 66.7959).dy)
      ..lineTo(p(247.482, 70.3878).dx, p(247.482, 70.3878).dy)
      ..lineTo(p(247.482, 73).dx, p(247.482, 73).dy)
      ..lineTo(p(247.482, 76.2653).dx, p(247.482, 76.2653).dy)
      ..lineTo(p(256.844, 81.4898).dx, p(256.844, 81.4898).dy)
      ..lineTo(p(261.005, 80.5102).dx, p(261.005, 80.5102).dy)
      ..lineTo(p(267.246, 82.4694).dx, p(267.246, 82.4694).dy)
      ..lineTo(p(277.649, 103.694).dx, p(277.649, 103.694).dy)
      ..lineTo(p(283.89, 103.694).dx, p(283.89, 103.694).dy)
      ..lineTo(p(288.051, 102.388).dx, p(288.051, 102.388).dy)
      ..lineTo(p(294.292, 102.388).dx, p(294.292, 102.388).dy)
      ..close();
  }
}
