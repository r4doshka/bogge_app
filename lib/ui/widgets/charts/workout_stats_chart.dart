import 'package:bogge_app/features/workouts/models/workout_stats_model.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_border_radius.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/utils/gradients.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WorkoutStatsChart extends ConsumerWidget {
  final WorkoutStatsModel data;

  const WorkoutStatsChart({required this.data, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);
    final points = data.points;

    if (points.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(child: Text('Нет данных')),
      );
    }

    final rawMaxY = points
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    final hasValues = rawMaxY > 0;

    final spots = points.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value.toDouble());
    }).toList();

    final chartMaxY = hasValues ? rawMaxY * 1.2 : 75.0;
    final yInterval = chartMaxY / 3;

    return SizedBox(
      height: 140.h,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (points.length - 1).toDouble(),
          minY: 0,
          maxY: chartMaxY,
          gridData: FlGridData(
            show: true,
            horizontalInterval: yInterval,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              if (value == 0) {
                return FlLine(color: Colors.transparent, strokeWidth: 0);
              }

              return FlLine(color: palette.gray, strokeWidth: 1);
            },
            getDrawingVerticalLine: (value) {
              if (value <= 0 || value >= points.length - 1) {
                return FlLine(color: Colors.transparent, strokeWidth: 0);
              }

              return FlLine(
                color: palette.gray,
                strokeWidth: 1,
                dashArray: [4, 4],
              );
            },
          ),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(y: chartMaxY, color: palette.gray, strokeWidth: 1),
            ],
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 42,
                interval: yInterval,
                getTitlesWidget: (value, meta) {
                  final index = (value / yInterval).round();

                  if (index < 0 || index > 3) {
                    return const SizedBox();
                  }

                  final label = index == 3
                      ? chartMaxY.ceil()
                      : (chartMaxY * index / 3).round();

                  return Padding(
                    padding: EdgeInsetsDirectional.only(start: AppSpace.s4.h),
                    child: Text(
                      label.toString(),
                      style: text_s11_w400_ls01.copyWith(color: palette.gray3),
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();

                  if (index < 0 || index >= points.length) {
                    return const SizedBox();
                  }

                  return Padding(
                    padding: EdgeInsetsDirectional.only(top: AppSpace.s4.h),
                    child: Text(
                      points[index].tooltipLabel,
                      style: text_s11_w400_ls01.copyWith(color: palette.gray3),
                    ),
                  );
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            enabled: true,
            getTouchedSpotIndicator: (barData, spotIndexes) {
              return spotIndexes.map((index) {
                return TouchedSpotIndicatorData(
                  FlLine(color: palette.primary, strokeWidth: 0.5),
                  FlDotData(show: false),
                );
              }).toList();
            },
            touchTooltipData: LineTouchTooltipData(
              tooltipPadding: EdgeInsets.symmetric(
                vertical: AppSpace.s4,
                horizontal: AppSpace.s8,
              ),
              tooltipBorderRadius: AppBorderRadius.all8,
              getTooltipColor: (_) => palette.primary,
              getTooltipItems: (spots) {
                return spots.map((spot) {
                  final index = spot.x.toInt();
                  final point = points[index];

                  return LineTooltipItem(
                    '${point.tooltipLabel}\n${point.value}',
                    text_s11_w400_ls01.copyWith(color: palette.white),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              barWidth: 1,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              gradient: LinearGradient(
                colors: [const Color(0xFFA0816C), const Color(0xFFA0816C)],
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: AppGradients.chartBelowBarDataGradient,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
