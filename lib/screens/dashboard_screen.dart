import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:infrawatch/services/monitoring_service.dart';
import 'package:infrawatch/models/server.dart';
import 'package:infrawatch/models/service.dart';
import 'package:infrawatch/models/alert.dart';
import 'package:infrawatch/widgets/status_card.dart';
import 'package:infrawatch/widgets/uptime_chart.dart';
import 'package:infrawatch/widgets/alert_list_tile.dart';
import 'package:infrawatch/utils/gradients.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _monitoringService = MonitoringService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusSummary = _monitoringService.statusSummary;
    final recentAlerts = _monitoringService.alerts.take(5).toList();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'System Overview',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildStatusCards(statusSummary),
              const SizedBox(height: 24),
              Text(
                'Server Performance',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildServerMetrics(),
              const SizedBox(height: 24),
              Text(
                'Uptime Trends',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const UptimeChart(),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Alerts',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      DefaultTabController.of(context)?.animateTo(2);
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildRecentAlerts(recentAlerts),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCards(Map<String, int> statusSummary) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        StatusCard(
          title: 'Servers Online',
          value: '${statusSummary['upServers']}/${statusSummary['upServers']! + statusSummary['downServers']! + statusSummary['warningServers']!}',
          icon: Icons.dns,
          color: Colors.green,
          percentage: statusSummary['upServers']! / (statusSummary['upServers']! + statusSummary['downServers']! + statusSummary['warningServers']!) * 100,
        ),
        StatusCard(
          title: 'Services Active',
          value: '${statusSummary['upServices']}/${statusSummary['upServices']! + statusSummary['downServices']! + statusSummary['warningServices']!}',
          icon: Icons.cloud_done,
          color: Colors.blue,
          percentage: statusSummary['upServices']! / (statusSummary['upServices']! + statusSummary['downServices']! + statusSummary['warningServices']!) * 100,
        ),
        StatusCard(
          title: 'Critical Alerts',
          value: '${_monitoringService.criticalAlerts.length}',
          icon: Icons.warning,
          color: Colors.red,
          percentage: null,
        ),
        StatusCard(
          title: 'System Health',
          value: _getSystemHealth(statusSummary),
          icon: Icons.favorite,
          color: _getSystemHealthColor(statusSummary),
          percentage: null,
        ),
      ],
    );
  }

  Widget _buildServerMetrics() {
    final servers = _monitoringService.servers.where((s) => s.status != ServerStatus.down).toList();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: servers.map((server) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.computer,
                      color: _getServerStatusColor(server.status),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        server.name,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    Text(
                      server.ipAddress,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricBar('CPU', server.cpuUsage, Colors.blue),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMetricBar('Memory', server.memoryUsage, Colors.orange),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMetricBar('Disk', server.diskUsage, Colors.purple),
                    ),
                  ],
                ),
                if (servers.last != server) const Divider(height: 24),
              ],
            ),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildMetricBar(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '${value.toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value / 100,
          backgroundColor: color.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildRecentAlerts(List<Alert> alerts) {
    if (alerts.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 48,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              Text(
                'No recent alerts',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'All systems are running normally',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Column(
        children: alerts.map((alert) => AlertListTile(alert: alert)).toList(),
      ),
    );
  }

  String _getSystemHealth(Map<String, int> statusSummary) {
    final totalServers = statusSummary['upServers']! + statusSummary['downServers']! + statusSummary['warningServers']!;
    final totalServices = statusSummary['upServices']! + statusSummary['downServices']! + statusSummary['warningServices']!;
    
    final serverHealth = statusSummary['upServers']! / totalServers;
    final serviceHealth = statusSummary['upServices']! / totalServices;
    
    final overallHealth = (serverHealth + serviceHealth) / 2;
    
    if (overallHealth >= 0.9) return 'Excellent';
    if (overallHealth >= 0.75) return 'Good';
    if (overallHealth >= 0.5) return 'Fair';
    return 'Poor';
  }

  Color _getSystemHealthColor(Map<String, int> statusSummary) {
    final health = _getSystemHealth(statusSummary);
    switch (health) {
      case 'Excellent': return Colors.green;
      case 'Good': return Colors.lightGreen;
      case 'Fair': return Colors.orange;
      default: return Colors.red;
    }
  }

  Color _getServerStatusColor(ServerStatus status) {
    switch (status) {
      case ServerStatus.up: return Colors.green;
      case ServerStatus.warning: return Colors.orange;
      case ServerStatus.down: return Colors.red;
      case ServerStatus.maintenance: return Colors.blue;
    }
  }
}