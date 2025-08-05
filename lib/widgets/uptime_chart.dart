import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:infrawatch/services/monitoring_service.dart';
import 'dart:math';

class UptimeChart extends StatelessWidget {
  const UptimeChart({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monitoringService = MonitoringService();
    
    // Generate sample uptime data for the chart
    final uptimeData = _generateUptimeData();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'System Uptime (24h)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '98.5% avg',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 25,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 4,
                        getTitlesWidget: (value, meta) {
                          final hour = value.toInt();
                          if (hour % 4 == 0) {
                            return Text(
                              '${hour}h',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.outline,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 25,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}%',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 23,
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: uptimeData,
                      isCurved: true,
                      color: theme.colorScheme.primary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem(context, 'Servers', Colors.blue, '4/4 Online'),
                _buildLegendItem(context, 'Services', Colors.green, '3/4 Active'),
                _buildLegendItem(context, 'Network', Colors.orange, 'Stable'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color, String value) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  List<FlSpot> _generateUptimeData() {
    final random = Random();
    final spots = <FlSpot>[];
    
    for (int i = 0; i <= 23; i++) {
      // Generate uptime percentage with some variation
      double uptime = 95 + random.nextDouble() * 5; // 95-100% uptime
      
      // Add some dips for realism
      if (random.nextDouble() < 0.1) {
        uptime = 85 + random.nextDouble() * 10; // Occasional dips to 85-95%
      }
      
      spots.add(FlSpot(i.toDouble(), uptime));
    }
    
    return spots;
  }
}