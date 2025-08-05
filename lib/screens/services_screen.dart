import 'package:flutter/material.dart';
import 'package:infrawatch/services/monitoring_service.dart';
import 'package:infrawatch/models/server.dart';
import 'package:infrawatch/models/service.dart';
import 'package:infrawatch/widgets/server_card.dart';
import 'package:infrawatch/widgets/service_card.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final _monitoringService = MonitoringService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          Container(
            color: theme.colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(
                  icon: Icon(Icons.dns),
                  text: 'Servers',
                ),
                Tab(
                  icon: Icon(Icons.cloud),
                  text: 'Services',
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildServersTab(),
                _buildServicesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServersTab() {
    final servers = _monitoringService.servers;

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: servers.length,
        itemBuilder: (context, index) {
          final server = servers[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ServerCard(
              server: server,
              onTap: () => _showServerDetails(context, server),
            ),
          );
        },
      ),
    );
  }

  Widget _buildServicesTab() {
    final services = _monitoringService.services;

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ServiceCard(
              service: service,
              onTap: () => _showServiceDetails(context, service),
            ),
          );
        },
      ),
    );
  }

  void _showServerDetails(BuildContext context, Server server) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.computer,
                            color: _getServerStatusColor(server.status),
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  server.name,
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                                Text(
                                  server.ipAddress,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Chip(
                            label: Text(_getServerStatusText(server.status)),
                            backgroundColor: _getServerStatusColor(server.status).withValues(alpha: 0.2),
                            labelStyle: TextStyle(
                              color: _getServerStatusColor(server.status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Resource Usage',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildResourceUsage(server),
                      const SizedBox(height: 24),
                      Text(
                        'Uptime History (24h)',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildUptimeHistory(server.uptimeHistory),
                      const SizedBox(height: 16),
                      Text(
                        'Last checked: ${_formatDateTime(server.lastChecked)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showServiceDetails(BuildContext context, MonitoredService service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getServiceTypeIcon(service.type),
                            color: _getServiceStatusColor(service.status),
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service.name,
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                                Text(
                                  service.url,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Chip(
                            label: Text(_getServiceStatusText(service.status)),
                            backgroundColor: _getServiceStatusColor(service.status).withValues(alpha: 0.2),
                            labelStyle: TextStyle(
                              color: _getServiceStatusColor(service.status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'Response Time',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${service.responseTime}ms',
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'Service Type',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      service.type.name.toUpperCase(),
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Check History (24h)',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildServiceHistory(service.checkHistory),
                      const SizedBox(height: 16),
                      Text(
                        'Last checked: ${_formatDateTime(service.lastChecked)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResourceUsage(Server server) {
    return Column(
      children: [
        _buildUsageRow('CPU Usage', server.cpuUsage, Colors.blue),
        const SizedBox(height: 12),
        _buildUsageRow('Memory Usage', server.memoryUsage, Colors.orange),
        const SizedBox(height: 12),
        _buildUsageRow('Disk Usage', server.diskUsage, Colors.purple),
      ],
    );
  }

  Widget _buildUsageRow(String label, double value, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Expanded(
          child: LinearProgressIndicator(
            value: value / 100,
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${value.toStringAsFixed(1)}%',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildUptimeHistory(List<UptimeRecord> history) {
    return SizedBox(
      height: 40,
      child: Row(
        children: history.map((record) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: record.isUp ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildServiceHistory(List<ServiceCheck> history) {
    return SizedBox(
      height: 40,
      child: Row(
        children: history.map((check) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: _getServiceStatusColor(check.status),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getServerStatusColor(ServerStatus status) {
    switch (status) {
      case ServerStatus.up: return Colors.green;
      case ServerStatus.warning: return Colors.orange;
      case ServerStatus.down: return Colors.red;
      case ServerStatus.maintenance: return Colors.blue;
    }
  }

  Color _getServiceStatusColor(ServiceStatus status) {
    switch (status) {
      case ServiceStatus.up: return Colors.green;
      case ServiceStatus.warning: return Colors.orange;
      case ServiceStatus.down: return Colors.red;
      case ServiceStatus.maintenance: return Colors.blue;
    }
  }

  String _getServerStatusText(ServerStatus status) {
    switch (status) {
      case ServerStatus.up: return 'Online';
      case ServerStatus.warning: return 'Warning';
      case ServerStatus.down: return 'Offline';
      case ServerStatus.maintenance: return 'Maintenance';
    }
  }

  String _getServiceStatusText(ServiceStatus status) {
    switch (status) {
      case ServiceStatus.up: return 'Active';
      case ServiceStatus.warning: return 'Warning';
      case ServiceStatus.down: return 'Down';
      case ServiceStatus.maintenance: return 'Maintenance';
    }
  }

  IconData _getServiceTypeIcon(ServiceType type) {
    switch (type) {
      case ServiceType.http:
      case ServiceType.https: return Icons.language;
      case ServiceType.database: return Icons.storage;
      case ServiceType.tcp: return Icons.cable;
      case ServiceType.ping: return Icons.network_ping;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}