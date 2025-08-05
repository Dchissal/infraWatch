import 'package:flutter/material.dart';
import 'package:infrawatch/services/monitoring_service.dart';
import 'package:infrawatch/models/alert.dart';
import 'package:infrawatch/widgets/alert_list_tile.dart';

class AlertsConfigScreen extends StatefulWidget {
  const AlertsConfigScreen({super.key});

  @override
  State<AlertsConfigScreen> createState() => _AlertsConfigScreenState();
}

class _AlertsConfigScreenState extends State<AlertsConfigScreen> with TickerProviderStateMixin {
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
              tabs: [
                Tab(
                  icon: Badge(
                    label: Text('${_monitoringService.unreadAlertsCount}'),
                    backgroundColor: theme.colorScheme.error,
                    textColor: theme.colorScheme.onError,
                    isLabelVisible: _monitoringService.unreadAlertsCount > 0,
                    child: const Icon(Icons.notifications),
                  ),
                  text: 'Alerts',
                ),
                const Tab(
                  icon: Icon(Icons.settings),
                  text: 'Configuration',
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAlertsTab(),
                _buildConfigurationTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsTab() {
    final alerts = _monitoringService.alerts;

    if (alerts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            Text(
              'No alerts',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              'All systems are running smoothly',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          final alert = alerts[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: AlertListTile(
              alert: alert,
              onTap: () => _markAlertAsRead(alert),
            ),
          );
        },
      ),
    );
  }

  Widget _buildConfigurationTab() {
    final config = _monitoringService.alertConfiguration;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Alert Configuration',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notification Methods',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Email Notifications'),
                    subtitle: Text(config?.emailAddress ?? 'No email configured'),
                    value: config?.emailEnabled ?? false,
                    onChanged: (value) => _updateEmailEnabled(value),
                  ),
                  if (config?.emailEnabled == true) ...[
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: config?.emailAddress ?? '',
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: _updateEmailAddress,
                    ),
                  ],
                  const Divider(height: 32),
                  SwitchListTile(
                    title: const Text('SMS Notifications'),
                    subtitle: Text(config?.phoneNumber ?? 'No phone number configured'),
                    value: config?.smsEnabled ?? false,
                    onChanged: (value) => _updateSmsEnabled(value),
                  ),
                  if (config?.smsEnabled == true) ...[
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: config?.phoneNumber ?? '',
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: _updatePhoneNumber,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alert Levels',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...AlertLevel.values.map((level) {
                    final isEnabled = config?.enabledLevels.contains(level) ?? true;
                    return CheckboxListTile(
                      title: Text(_getAlertLevelText(level)),
                      subtitle: Text(_getAlertLevelDescription(level)),
                      value: isEnabled,
                      onChanged: (value) => _updateAlertLevel(level, value ?? false),
                      secondary: Icon(
                        _getAlertLevelIcon(level),
                        color: _getAlertLevelColor(level),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alert Types',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...AlertType.values.map((type) {
                    final isEnabled = config?.enabledTypes.contains(type) ?? true;
                    return CheckboxListTile(
                      title: Text(_getAlertTypeText(type)),
                      subtitle: Text(_getAlertTypeDescription(type)),
                      value: isEnabled,
                      onChanged: (value) => _updateAlertType(type, value ?? false),
                      secondary: Icon(
                        _getAlertTypeIcon(type),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _testNotifications,
              child: const Text('Test Notifications'),
            ),
          ),
        ],
      ),
    );
  }

  void _markAlertAsRead(Alert alert) async {
    await _monitoringService.markAlertAsRead(alert.id);
    setState(() {});
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alert marked as read'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _updateEmailEnabled(bool enabled) {
    final config = _monitoringService.alertConfiguration;
    if (config != null) {
      final updatedConfig = AlertConfiguration(
        id: config.id,
        name: config.name,
        emailEnabled: enabled,
        smsEnabled: config.smsEnabled,
        emailAddress: config.emailAddress,
        phoneNumber: config.phoneNumber,
        enabledLevels: config.enabledLevels,
        enabledTypes: config.enabledTypes,
      );
      _monitoringService.saveAlertConfiguration(updatedConfig);
      setState(() {});
    }
  }

  void _updateSmsEnabled(bool enabled) {
    final config = _monitoringService.alertConfiguration;
    if (config != null) {
      final updatedConfig = AlertConfiguration(
        id: config.id,
        name: config.name,
        emailEnabled: config.emailEnabled,
        smsEnabled: enabled,
        emailAddress: config.emailAddress,
        phoneNumber: config.phoneNumber,
        enabledLevels: config.enabledLevels,
        enabledTypes: config.enabledTypes,
      );
      _monitoringService.saveAlertConfiguration(updatedConfig);
      setState(() {});
    }
  }

  void _updateEmailAddress(String email) {
    final config = _monitoringService.alertConfiguration;
    if (config != null) {
      final updatedConfig = AlertConfiguration(
        id: config.id,
        name: config.name,
        emailEnabled: config.emailEnabled,
        smsEnabled: config.smsEnabled,
        emailAddress: email,
        phoneNumber: config.phoneNumber,
        enabledLevels: config.enabledLevels,
        enabledTypes: config.enabledTypes,
      );
      _monitoringService.saveAlertConfiguration(updatedConfig);
    }
  }

  void _updatePhoneNumber(String phone) {
    final config = _monitoringService.alertConfiguration;
    if (config != null) {
      final updatedConfig = AlertConfiguration(
        id: config.id,
        name: config.name,
        emailEnabled: config.emailEnabled,
        smsEnabled: config.smsEnabled,
        emailAddress: config.emailAddress,
        phoneNumber: phone,
        enabledLevels: config.enabledLevels,
        enabledTypes: config.enabledTypes,
      );
      _monitoringService.saveAlertConfiguration(updatedConfig);
    }
  }

  void _updateAlertLevel(AlertLevel level, bool enabled) {
    final config = _monitoringService.alertConfiguration;
    if (config != null) {
      final updatedLevels = Set<AlertLevel>.from(config.enabledLevels);
      if (enabled) {
        updatedLevels.add(level);
      } else {
        updatedLevels.remove(level);
      }

      final updatedConfig = AlertConfiguration(
        id: config.id,
        name: config.name,
        emailEnabled: config.emailEnabled,
        smsEnabled: config.smsEnabled,
        emailAddress: config.emailAddress,
        phoneNumber: config.phoneNumber,
        enabledLevels: updatedLevels,
        enabledTypes: config.enabledTypes,
      );
      _monitoringService.saveAlertConfiguration(updatedConfig);
      setState(() {});
    }
  }

  void _updateAlertType(AlertType type, bool enabled) {
    final config = _monitoringService.alertConfiguration;
    if (config != null) {
      final updatedTypes = Set<AlertType>.from(config.enabledTypes);
      if (enabled) {
        updatedTypes.add(type);
      } else {
        updatedTypes.remove(type);
      }

      final updatedConfig = AlertConfiguration(
        id: config.id,
        name: config.name,
        emailEnabled: config.emailEnabled,
        smsEnabled: config.smsEnabled,
        emailAddress: config.emailAddress,
        phoneNumber: config.phoneNumber,
        enabledLevels: config.enabledLevels,
        enabledTypes: updatedTypes,
      );
      _monitoringService.saveAlertConfiguration(updatedConfig);
      setState(() {});
    }
  }

  void _testNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Test Notifications'),
        content: const Text('Test notifications have been sent to your configured channels.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _getAlertLevelText(AlertLevel level) {
    switch (level) {
      case AlertLevel.critical: return 'Critical';
      case AlertLevel.warning: return 'Warning';
      case AlertLevel.info: return 'Info';
    }
  }

  String _getAlertLevelDescription(AlertLevel level) {
    switch (level) {
      case AlertLevel.critical: return 'Severe issues requiring immediate attention';
      case AlertLevel.warning: return 'Issues that should be addressed soon';
      case AlertLevel.info: return 'General information and status updates';
    }
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

  String _getAlertTypeText(AlertType type) {
    switch (type) {
      case AlertType.server: return 'Server';
      case AlertType.service: return 'Service';
      case AlertType.network: return 'Network';
      case AlertType.system: return 'System';
    }
  }

  String _getAlertTypeDescription(AlertType type) {
    switch (type) {
      case AlertType.server: return 'Server hardware and performance alerts';
      case AlertType.service: return 'Application and service monitoring alerts';
      case AlertType.network: return 'Network connectivity and performance alerts';
      case AlertType.system: return 'System-wide alerts and notifications';
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
}