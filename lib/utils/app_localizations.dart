import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'app_title': 'InfraWatch',
      'dashboard': 'Dashboard',
      'services': 'Services',
      'reports': 'Reports',
      'alerts': 'Alerts',
      'settings': 'Settings',
      'login': 'Login',
      'logout': 'Logout',
      'email': 'Email',
      'password': 'Password',
      'server_status': 'Server Status',
      'uptime': 'Uptime',
      'response_time': 'Response Time',
      'cpu_usage': 'CPU Usage',
      'memory_usage': 'Memory Usage',
      'disk_usage': 'Disk Usage',
      'system_overview': 'System Overview',
      'recent_alerts': 'Recent Alerts',
      'generate_report': 'Generate Report',
      'sla_compliance': 'SLA Compliance',
      'monitoring_settings': 'Monitoring Settings',
      'notification_settings': 'Notification Settings',
      'security_settings': 'Security Settings',
      'interface_settings': 'Interface Settings',
      'check_interval': 'Check Interval',
      'timeout_duration': 'Timeout Duration',
      'retry_attempts': 'Retry Attempts',
      'data_retention': 'Data Retention',
      'email_notifications': 'Email Notifications',
      'sms_notifications': 'SMS Notifications',
      'webhook_notifications': 'Webhook Notifications',
      'two_factor_auth': 'Two-Factor Authentication',
      'password_expiry': 'Password Expiry',
      'session_timeout': 'Session Timeout',
      'audit_logging': 'Audit Logging',
      'ssl_required': 'SSL Required',
      'theme': 'Theme',
      'language': 'Language',
      'refresh_interval': 'Refresh Interval',
      'animations': 'Animations',
      'push_notifications': 'Push Notifications',
    },
    'pt': {
      'app_title': 'InfraWatch',
      'dashboard': 'Dashboard',
      'services': 'Serviços',
      'reports': 'Relatórios',
      'alerts': 'Alertas',
      'settings': 'Configurações',
      'login': 'Entrar',
      'logout': 'Sair',
      'email': 'Email',
      'password': 'Senha',
      'server_status': 'Status do Servidor',
      'uptime': 'Tempo Online',
      'response_time': 'Tempo de Resposta',
      'cpu_usage': 'Uso da CPU',
      'memory_usage': 'Uso da Memória',
      'disk_usage': 'Uso do Disco',
      'system_overview': 'Visão Geral do Sistema',
      'recent_alerts': 'Alertas Recentes',
      'generate_report': 'Gerar Relatório',
      'sla_compliance': 'Conformidade SLA',
      'monitoring_settings': 'Configurações de Monitoramento',
      'notification_settings': 'Configurações de Notificação',
      'security_settings': 'Configurações de Segurança',
      'interface_settings': 'Configurações de Interface',
      'check_interval': 'Intervalo de Verificação',
      'timeout_duration': 'Tempo Limite',
      'retry_attempts': 'Tentativas de Repetição',
      'data_retention': 'Retenção de Dados',
      'email_notifications': 'Notificações por Email',
      'sms_notifications': 'Notificações por SMS',
      'webhook_notifications': 'Notificações Webhook',
      'two_factor_auth': 'Autenticação de Dois Fatores',
      'password_expiry': 'Expiração da Senha',
      'session_timeout': 'Tempo Limite da Sessão',
      'audit_logging': 'Log de Auditoria',
      'ssl_required': 'SSL Obrigatório',
      'theme': 'Tema',
      'language': 'Idioma',
      'refresh_interval': 'Intervalo de Atualização',
      'animations': 'Animações',
      'push_notifications': 'Notificações Push',
    },
    'es': {
      'app_title': 'InfraWatch',
      'dashboard': 'Panel',
      'services': 'Servicios',
      'reports': 'Informes',
      'alerts': 'Alertas',
      'settings': 'Configuración',
      'login': 'Iniciar Sesión',
      'logout': 'Cerrar Sesión',
      'email': 'Correo',
      'password': 'Contraseña',
      'server_status': 'Estado del Servidor',
      'uptime': 'Tiempo Activo',
      'response_time': 'Tiempo de Respuesta',
      'cpu_usage': 'Uso de CPU',
      'memory_usage': 'Uso de Memoria',
      'disk_usage': 'Uso de Disco',
      'system_overview': 'Resumen del Sistema',
      'recent_alerts': 'Alertas Recientes',
      'generate_report': 'Generar Informe',
      'sla_compliance': 'Cumplimiento SLA',
      'monitoring_settings': 'Configuración de Monitoreo',
      'notification_settings': 'Configuración de Notificaciones',
      'security_settings': 'Configuración de Seguridad',
      'interface_settings': 'Configuración de Interfaz',
      'check_interval': 'Intervalo de Verificación',
      'timeout_duration': 'Duración de Tiempo Límite',
      'retry_attempts': 'Intentos de Reintento',
      'data_retention': 'Retención de Datos',
      'email_notifications': 'Notificaciones por Correo',
      'sms_notifications': 'Notificaciones SMS',
      'webhook_notifications': 'Notificaciones Webhook',
      'two_factor_auth': 'Autenticación de Dos Factores',
      'password_expiry': 'Expiración de Contraseña',
      'session_timeout': 'Tiempo Límite de Sesión',
      'audit_logging': 'Registro de Auditoría',
      'ssl_required': 'SSL Requerido',
      'theme': 'Tema',
      'language': 'Idioma',
      'refresh_interval': 'Intervalo de Actualización',
      'animations': 'Animaciones',
      'push_notifications': 'Notificaciones Push',
    },
  };

  String get appTitle => _localizedValues[locale.languageCode]?['app_title'] ?? 'InfraWatch';
  String get dashboard => _localizedValues[locale.languageCode]?['dashboard'] ?? 'Dashboard';
  String get services => _localizedValues[locale.languageCode]?['services'] ?? 'Services';
  String get reports => _localizedValues[locale.languageCode]?['reports'] ?? 'Reports';
  String get alerts => _localizedValues[locale.languageCode]?['alerts'] ?? 'Alerts';
  String get settings => _localizedValues[locale.languageCode]?['settings'] ?? 'Settings';
  String get login => _localizedValues[locale.languageCode]?['login'] ?? 'Login';
  String get logout => _localizedValues[locale.languageCode]?['logout'] ?? 'Logout';
  String get email => _localizedValues[locale.languageCode]?['email'] ?? 'Email';
  String get password => _localizedValues[locale.languageCode]?['password'] ?? 'Password';
  String get serverStatus => _localizedValues[locale.languageCode]?['server_status'] ?? 'Server Status';
  String get uptime => _localizedValues[locale.languageCode]?['uptime'] ?? 'Uptime';
  String get responseTime => _localizedValues[locale.languageCode]?['response_time'] ?? 'Response Time';
  String get cpuUsage => _localizedValues[locale.languageCode]?['cpu_usage'] ?? 'CPU Usage';
  String get memoryUsage => _localizedValues[locale.languageCode]?['memory_usage'] ?? 'Memory Usage';
  String get diskUsage => _localizedValues[locale.languageCode]?['disk_usage'] ?? 'Disk Usage';
  String get systemOverview => _localizedValues[locale.languageCode]?['system_overview'] ?? 'System Overview';
  String get recentAlerts => _localizedValues[locale.languageCode]?['recent_alerts'] ?? 'Recent Alerts';
  String get generateReport => _localizedValues[locale.languageCode]?['generate_report'] ?? 'Generate Report';
  String get slaCompliance => _localizedValues[locale.languageCode]?['sla_compliance'] ?? 'SLA Compliance';

  // Helper method to get localized text by key
  String translate(String key) => _localizedValues[locale.languageCode]?[key] ?? key;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'pt', 'es'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}