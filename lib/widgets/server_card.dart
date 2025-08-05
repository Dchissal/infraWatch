import 'package:flutter/material.dart';
import 'package:infrawatch/models/server.dart';

class ServerCard extends StatelessWidget {
  final Server server;
  final VoidCallback? onTap;

  const ServerCard({
    super.key,
    required this.server,
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
                      color: _getStatusColor(server.status).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.computer,
                      color: _getStatusColor(server.status),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          server.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          server.ipAddress,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Chip(
                    label: Text(
                      _getStatusText(server.status),
                      style: TextStyle(
                        color: _getStatusColor(server.status),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: _getStatusColor(server.status).withValues(alpha: 0.1),
                    side: BorderSide(
                      color: _getStatusColor(server.status).withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                ],
              ),
              if (server.status != ServerStatus.down) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetric('CPU', server.cpuUsage, Colors.blue),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMetric('Memory', server.memoryUsage, Colors.orange),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMetric('Disk', server.diskUsage, Colors.purple),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Last checked: ${_formatLastChecked(server.lastChecked)}',
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

  Widget _buildMetric(String label, double value, Color color) {
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
        LinearProgressIndicator(
          value: value / 100,
          backgroundColor: color.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
        const SizedBox(height: 2),
        Text(
          '${value.toStringAsFixed(1)}%',
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(ServerStatus status) {
    switch (status) {
      case ServerStatus.up: return Colors.green;
      case ServerStatus.warning: return Colors.orange;
      case ServerStatus.down: return Colors.red;
      case ServerStatus.maintenance: return Colors.blue;
    }
  }

  String _getStatusText(ServerStatus status) {
    switch (status) {
      case ServerStatus.up: return 'ONLINE';
      case ServerStatus.warning: return 'WARNING';
      case ServerStatus.down: return 'OFFLINE';
      case ServerStatus.maintenance: return 'MAINTENANCE';
    }
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