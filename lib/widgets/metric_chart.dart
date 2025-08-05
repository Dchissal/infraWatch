import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MetricChart extends StatelessWidget {
  const MetricChart({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 20,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const style = TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  );
                  Widget text;
                  switch (value.toInt()) {
                    case 0:
                      text = const Text('Seg', style: style);
                      break;
                    case 1:
                      text = const Text('Ter', style: style);
                      break;
                    case 2:
                      text = const Text('Qua', style: style);
                      break;
                    case 3:
                      text = const Text('Qui', style: style);
                      break;
                    case 4:
                      text = const Text('Sex', style: style);
                      break;
                    case 5:
                      text = const Text('Sáb', style: style);
                      break;
                    case 6:
                      text = const Text('Dom', style: style);
                      break;
                    default:
                      text = const Text('', style: style);
                      break;
                  }
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: text,
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const style = TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  );
                  return Text('${value.toInt()}%', style: style);
                },
                reservedSize: 42,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          minX: 0,
          maxX: 6,
          minY: 80,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 99.2),
                FlSpot(1, 99.8),
                FlSpot(2, 98.5),
                FlSpot(3, 99.1),
                FlSpot(4, 99.9),
                FlSpot(5, 99.4),
                FlSpot(6, 99.7),
              ],
              isCurved: true,
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: theme.colorScheme.primary,
                    strokeWidth: 2,
                    strokeColor: theme.colorScheme.surface,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.3),
                    theme.colorScheme.primary.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}