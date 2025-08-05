import 'package:flutter/material.dart';
import 'package:infrawatch/models/alert.dart';
import 'package:intl/intl.dart';

class AlertListTile extends StatelessWidget {
  final Alert alert;
  final VoidCallback? onTap;

  const AlertListTile({
    super.key,
    required this.alert,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat('MMM dd, HH:mm');

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _getAlertLevelColor(alert.level).withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          _getAlertLevelIcon(alert.level),
          color: _getAlertLevelColor(alert.level),
          size: 20,
        ),
      ),
      title: Text(
        alert.title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: alert.isRead ? FontWeight.normal : FontWeight.bold,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            alert.description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (alert.sourceName != null) ...[
                Icon(
                  _getAlertTypeIcon(alert.type),
                  size: 12,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(width: 4),
                Text(
                  alert.sourceName!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                timeFormat.format(alert.timestamp),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Chip(
            label: Text(
              _getAlertLevelText(alert.level),
              style: TextStyle(
                color: _getAlertLevelColor(alert.level),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: _getAlertLevelColor(alert.level).withValues(alpha: 0.1),
            side: BorderSide(
              color: _getAlertLevelColor(alert.level).withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          if (!alert.isRead) ...[
            const SizedBox(height: 4),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  IconData _getAlertLevelIcon(AlertLevel level) {
    switch (level) {
      case AlertLevel.critical: return Icons.error;
      case AlertLevel.warning: return Icons.warning;
      case AlertLevel.info: return Icons.info;
    }
  }

  Color _getAlertLevelColor(AlertLevel level) {
    switch (level) {
      case AlertLevel.critical: return Colors.red;
      case AlertLevel.warning: return Colors.orange;
      case AlertLevel.info: return Colors.blue;
    }
  }

  IconData _getAlertTypeIcon(AlertType type) {
    switch (type) {
      case AlertType.server: return Icons.dns;
      case AlertType.service: return Icons.cloud;
      case AlertType.network: return Icons.network_check;
      case AlertType.system: return Icons.settings_system_daydream;
    }
  }

  String _getAlertLevelText(AlertLevel level) {
    switch (level) {
      case AlertLevel.critical: return 'CRITICAL';
      case AlertLevel.warning: return 'WARNING';
      case AlertLevel.info: return 'INFO';
    }
  }
}