import 'package:flutter/material.dart';
import 'package:infrawatch/models/service.dart';

class ServiceCard extends StatelessWidget {
  final MonitoredService service;
  final VoidCallback? onTap;

  const ServiceCard({
    super.key,
    required this.service,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getStatusColor(service.status).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getServiceTypeIcon(service.type),
                      color: _getStatusColor(service.status),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          service.url,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Chip(
                    label: Text(
                      _getStatusText(service.status),
                      style: TextStyle(
                        color: _getStatusColor(service.status),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: _getStatusColor(service.status).withValues(alpha: 0.1),
                    side: BorderSide(
                      color: _getStatusColor(service.status).withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      'Response Time',
                      service.status == ServiceStatus.down 
                        ? 'N/A' 
                        : '${service.responseTime}ms',
                      service.responseTime <= 200 
                        ? Colors.green 
                        : service.responseTime <= 1000 
                          ? Colors.orange 
                          : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoItem(
                      'Service Type',
                      service.type.name.toUpperCase(),
                      theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoItem(
                      'Uptime',
                      _calculateUptime(service.checkHistory),
                      Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Last checked: ${_formatLastChecked(service.lastChecked)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  if (onTap != null)
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: theme.colorScheme.outline,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(ServiceStatus status) {
    switch (status) {
      case ServiceStatus.up: return Colors.green;
      case ServiceStatus.warning: return Colors.orange;
      case ServiceStatus.down: return Colors.red;
      case ServiceStatus.maintenance: return Colors.blue;
    }
  }

  String _getStatusText(ServiceStatus status) {
    switch (status) {
      case ServiceStatus.up: return 'ACTIVE';
      case ServiceStatus.warning: return 'WARNING';
      case ServiceStatus.down: return 'DOWN';
      case ServiceStatus.maintenance: return 'MAINTENANCE';
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

  String _calculateUptime(List<ServiceCheck> history) {
    if (history.isEmpty) return 'N/A';
    
    final upCount = history.where((check) => check.status == ServiceStatus.up).length;
    final percentage = (upCount / history.length) * 100;
    return '${percentage.toStringAsFixed(1)}%';
  }

  String _formatLastChecked(DateTime lastChecked) {
    final now = DateTime.now();
    final difference = now.difference(lastChecked);

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