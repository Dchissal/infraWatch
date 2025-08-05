class SystemConfiguration {
  final String id;
  final MonitoringSettings monitoring;
  final NotificationSettings notifications;
  final SecuritySettings security;
  final IntegrationSettings integrations;
  final UISettings ui;
  final DateTime lastUpdated;
  final String updatedBy;

  SystemConfiguration({
    required this.id,
    required this.monitoring,
    required this.notifications,
    required this.security,
    required this.integrations,
    required this.ui,
    required this.lastUpdated,
    required this.updatedBy,
  });
}

class MonitoringSettings {
  final int defaultCheckInterval; // in seconds
  final int timeoutDuration; // in seconds
  final int retryAttempts;
  final bool enableHistoricalData;
  final int dataRetentionDays;
  final Map<String, int> customIntervals; // service-specific intervals
  final List<String> enabledProtocols;

  MonitoringSettings({
    required this.defaultCheckInterval,
    required this.timeoutDuration,
    required this.retryAttempts,
    required this.enableHistoricalData,
    required this.dataRetentionDays,
    required this.customIntervals,
    required this.enabledProtocols,
  });
}

class NotificationSettings {
  final bool emailEnabled;
  final bool smsEnabled;
  final bool webhookEnabled;
  final bool pushNotificationsEnabled;
  final String defaultEmailRecipient;
  final String defaultSmsRecipient;
  final List<String> webhookUrls;
  final Map<AlertLevel, NotificationChannel> alertChannels;
  final bool enableEscalation;
  final int escalationTimeMinutes;

  NotificationSettings({
    required this.emailEnabled,
    required this.smsEnabled,
    required this.webhookEnabled,
    required this.pushNotificationsEnabled,
    required this.defaultEmailRecipient,
    required this.defaultSmsRecipient,
    required this.webhookUrls,
    required this.alertChannels,
    required this.enableEscalation,
    required this.escalationTimeMinutes,
  });
}

class SecuritySettings {
  final bool twoFactorEnabled;
  final int passwordExpiryDays;
  final int sessionTimeoutMinutes;
  final bool auditLoggingEnabled;
  final List<String> allowedIPRanges;
  final bool sslRequired;
  final String encryptionMethod;

  SecuritySettings({
    required this.twoFactorEnabled,
    required this.passwordExpiryDays,
    required this.sessionTimeoutMinutes,
    required this.auditLoggingEnabled,
    required this.allowedIPRanges,
    required this.sslRequired,
    required this.encryptionMethod,
  });
}

class IntegrationSettings {
  final bool snmpEnabled;
  final bool apiEnabled;
  final bool webhookEnabled;
  final Map<String, String> externalSystems;
  final List<APIKey> apiKeys;
  final SNMPConfig snmpConfig;

  IntegrationSettings({
    required this.snmpEnabled,
    required this.apiEnabled,
    required this.webhookEnabled,
    required this.externalSystems,
    required this.apiKeys,
    required this.snmpConfig,
  });
}

class UISettings {
  final String defaultTheme; // 'light', 'dark', 'auto'
  final String defaultLanguage;
  final int dashboardRefreshInterval;
  final bool showAnimations;
  final List<String> enabledWidgets;
  final Map<String, dynamic> layoutConfiguration;

  UISettings({
    required this.defaultTheme,
    required this.defaultLanguage,
    required this.dashboardRefreshInterval,
    required this.showAnimations,
    required this.enabledWidgets,
    required this.layoutConfiguration,
  });
}

class APIKey {
  final String id;
  final String name;
  final String key;
  final List<String> permissions;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final bool isActive;

  APIKey({
    required this.id,
    required this.name,
    required this.key,
    required this.permissions,
    required this.createdAt,
    this.expiresAt,
    required this.isActive,
  });
}

class SNMPConfig {
  final String version; // v1, v2c, v3
  final String community;
  final int port;
  final int timeout;
  final String? username;
  final String? authProtocol;
  final String? authPassword;
  final String? privProtocol;
  final String? privPassword;

  SNMPConfig({
    required this.version,
    required this.community,
    required this.port,
    required this.timeout,
    this.username,
    this.authProtocol,
    this.authPassword,
    this.privProtocol,
    this.privPassword,
  });
}

enum NotificationChannel {
  email,
  sms,
  webhook,
  push,
  all
}

enum AlertLevel {
  info,
  warning,
  critical
}