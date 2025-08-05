import 'package:flutter/material.dart';
import 'package:infrawatch/models/report.dart';
import 'package:intl/intl.dart';

class ReportCard extends StatelessWidget {
  final Report report;
  final VoidCallback? onTap;
  final VoidCallback? onDownload;

  const ReportCard({
    super.key,
    required this.report,
    this.onTap,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getTypeColor().withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getTypeIcon(),
                        color: _getTypeColor(),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _getTypeLabel(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  report.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.date_range,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${DateFormat('dd/MM/yy').format(report.startDate)} - ${DateFormat('dd/MM/yy').format(report.endDate)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.person,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      report.generatedBy,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (report.status == ReportStatus.completed && onDownload != null) ...[
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: onDownload,
                        icon: Icon(
                          Icons.download,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ],
                ),
                if (report.metrics.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: report.metrics.take(3).map((metric) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${metric.name}: ${metric.value}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    final status = report.status;
    Color backgroundColor;
    Color textColor;
    String label;

    switch (status) {
      case ReportStatus.completed:
        backgroundColor = Colors.green.withValues(alpha: 0.1);
        textColor = Colors.green;
        label = 'Concluído';
        break;
      case ReportStatus.generating:
        backgroundColor = Colors.blue.withValues(alpha: 0.1);
        textColor = Colors.blue;
        label = 'Gerando';
        break;
      case ReportStatus.failed:
        backgroundColor = Colors.red.withValues(alpha: 0.1);
        textColor = Colors.red;
        label = 'Falhou';
        break;
      case ReportStatus.scheduled:
        backgroundColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange;
        label = 'Agendado';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getTypeColor() {
    switch (report.type) {
      case ReportType.uptime:
        return Colors.green;
      case ReportType.performance:
        return Colors.blue;
      case ReportType.sla:
        return Colors.purple;
      case ReportType.alerts:
        return Colors.orange;
      case ReportType.usage:
        return Colors.teal;
      case ReportType.security:
        return Colors.red;
      case ReportType.comprehensive:
        return Colors.indigo;
    }
  }

  IconData _getTypeIcon() {
    switch (report.type) {
      case ReportType.uptime:
        return Icons.trending_up;
      case ReportType.performance:
        return Icons.speed;
      case ReportType.sla:
        return Icons.assignment;
      case ReportType.alerts:
        return Icons.notifications;
      case ReportType.usage:
        return Icons.pie_chart;
      case ReportType.security:
        return Icons.security;
      case ReportType.comprehensive:
        return Icons.analytics;
    }
  }

  String _getTypeLabel() {
    switch (report.type) {
      case ReportType.uptime:
        return 'Relatório de Uptime';
      case ReportType.performance:
        return 'Relatório de Performance';
      case ReportType.sla:
        return 'Relatório de SLA';
      case ReportType.alerts:
        return 'Relatório de Alertas';
      case ReportType.usage:
        return 'Relatório de Uso';
      case ReportType.security:
        return 'Relatório de Segurança';
      case ReportType.comprehensive:
        return 'Relatório Completo';
    }
  }
}